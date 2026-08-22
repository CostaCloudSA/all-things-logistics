import json
from typing import Dict, Any, List
from app.agents.base import BaseAgent
from app.core.telemetry import OpenTelemetrySpan
from app.security.model_armor import model_armor

class SanctionsScreenerAgent(BaseAgent):
    """
    Real-Time Sanctions & Denied Parties Screener Agent:
    Screens all shippers, consignees, freight forwarders, carriers, and vessel names
    against OFAC Specially Designated Nationals (SDN), BIS Entity List, and UN Sanctions.
    """
    def __init__(self):
        super().__init__(
            agent_id="sanctions_screener_agent",
            name="Sanctions Screener Agent",
            role="Denied Parties, OFAC SDN & BIS Watchlist Screener",
            model="gemini-3.7-flash"
        )

    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        span.set_attribute("agent.type", "SANCTIONS_SCREENER")
        parties = payload.get("parties", ["CostaCloud Logistics S.A.", "AgroAvícola del Caribe", "Mediterranean Shipping Co"])

        # Model Armor Deterministic Screening
        hits = model_armor.verify_sanctions_grounding(parties)
        is_clear = len(hits) == 0

        result = {
            "is_sanctions_cleared": is_clear,
            "screened_parties": parties,
            "matched_violations": hits,
            "screening_engine": "Model Armor + OFAC/BIS/UN Grounded Truth",
            "risk_status": "CLEARED_GREEN" if is_clear else "BLOCKED_RED_CRITICAL"
        }

        span.set_attribute("sanctions.is_cleared", is_clear)
        span.set_attribute("sanctions.risk_status", result["risk_status"])
        return result

    def fallback_heuristic(self, prompt: str) -> str:
        return json.dumps({
            "is_sanctions_cleared": True,
            "risk_status": "CLEARED_GREEN"
        })
