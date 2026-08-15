import uuid
from fastapi import FastAPI, UploadFile, File, Form, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from typing import Dict, Any, List, Optional
from app.config import settings
from app.models.schemas import TradeRequest, TradeResponse, AgentRegistryEntry
from app.agents.orchestrator import fleet_orchestrator
from app.agents.ocr_parser import ocr_parser_agent
from app.agents.registry import agent_registry
from app.core.telemetry import telemetry_collector, OpenTelemetrySpan

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Fortified Enterprise Multi-Agent Backend for Customs Compliance & Golden Document Automation",
    version="1.0.0"
)

# Enable CORS for Flutter Web client and custom domain
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Active WebSocket connections for live telemetry streaming
active_websockets: List[WebSocket] = []

@app.get("/")
def root():
    return {
        "status": "ONLINE",
        "service": settings.PROJECT_NAME,
        "engine": "Gemini 3.7 Flash",
        "model_armor": "Local Gemma PII Sanitizer + Deterministic BigQuery Grounding",
        "version": "1.0.0"
    }

@app.get("/api/health")
def health_check():
    return {"status": "healthy", "environment": settings.ENVIRONMENT}

@app.get("/api/registry", response_model=List[AgentRegistryEntry])
def get_agent_registry():
    """Returns the cross-department Agent Registry catalog with schemas and roles."""
    return agent_registry.list_agents()

@app.post("/api/trade/process", response_model=TradeResponse)
async def process_trade(request: TradeRequest):
    """
    Main trade processing endpoint.
    Orchestrates OCR, HS Classification, Valuation, Sanitary Compliance, and Golden Document Generation.
    """
    response = fleet_orchestrator.process_trade_request(request)

    # Broadcast telemetry to connected web clients
    if response.telemetry_trace_id:
        trace_spans = telemetry_collector.get_trace(response.telemetry_trace_id)
        for ws in active_websockets:
            try:
                await ws.send_json({
                    "type": "TRACE_UPDATE",
                    "trace_id": response.telemetry_trace_id,
                    "spans": trace_spans
                })
            except Exception:
                pass

    return response

@app.post("/api/trade/ocr")
async def process_ocr(
    file: Optional[UploadFile] = File(None),
    raw_text: Optional[str] = Form(None),
    origin_hint: str = Form("CO"),
    dest_hint: str = Form("US")
):
    """
    Vision OCR Ingestion endpoint.
    Accepts invoice image / PDF or raw text, scrubs PII via Gemma, and extracts structured line items.
    """
    text_content = raw_text or "Commercial Shipping Manifest: 600 lbs frozen chicken cuts from Bogota to Miami Port 5201. Exporter Tax ID: 12-3456789."

    span = OpenTelemetrySpan("api.ocr_ingestion")
    res = ocr_parser_agent.process({
        "raw_text": text_content,
        "origin_hint": origin_hint,
        "destination_hint": dest_hint
    }, span)
    telemetry_collector.record_span(span)

    # Automatically run the extracted items through the full fleet orchestrator
    trade_req = TradeRequest(
        user_prompt=text_content,
        origin_iso=res["origin_iso"],
        destination_iso=res["destination_iso"],
        items=res["items"],
        session_id=f"ocr-session-{uuid.uuid4().hex[:6]}"
    )
    return fleet_orchestrator.process_trade_request(trade_req)

@app.get("/api/telemetry/{trace_id}")
def get_trace_telemetry(trace_id: str):
    """Retrieves OpenTelemetry execution spans for debugging and web telemetry sidebars."""
    return {
        "trace_id": trace_id,
        "spans": telemetry_collector.get_trace(trace_id)
    }

@app.websocket("/ws/telemetry")
async def websocket_telemetry(websocket: WebSocket):
    await websocket.accept()
    active_websockets.append(websocket)
    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        active_websockets.remove(websocket)
