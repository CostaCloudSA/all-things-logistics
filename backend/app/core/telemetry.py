import time
import uuid
from typing import Dict, Any, List

class OpenTelemetrySpan:
    """Mock/Lightweight OpenTelemetry Span that records execution attributes and logs for frontend inspection."""
    def __init__(self, name: str, parent_trace_id: str = None):
        self.name = name
        self.trace_id = parent_trace_id or str(uuid.uuid4())
        self.span_id = str(uuid.uuid4())[:8]
        self.start_time = time.time()
        self.end_time = None
        self.attributes: Dict[str, Any] = {}
        self.events: List[Dict[str, Any]] = []

    def set_attribute(self, key: str, value: Any):
        self.attributes[key] = value

    def add_event(self, name: str, attributes: Dict[str, Any] = None):
        self.events.append({
            "name": name,
            "timestamp": time.time(),
            "attributes": attributes or {}
        })

    def finish(self):
        self.end_time = time.time()
        self.attributes["execution_latency_ms"] = round((self.end_time - self.start_time) * 1000, 2)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "name": self.name,
            "trace_id": self.trace_id,
            "span_id": self.span_id,
            "latency_ms": self.attributes.get("execution_latency_ms", 0),
            "attributes": self.attributes,
            "events": self.events
        }

class TelemetryCollector:
    def __init__(self):
        self.active_traces: Dict[str, List[Dict[str, Any]]] = {}

    def record_span(self, span: OpenTelemetrySpan):
        span.finish()
        if span.trace_id not in self.active_traces:
            self.active_traces[span.trace_id] = []
        self.active_traces[span.trace_id].append(span.to_dict())

    def get_trace(self, trace_id: str) -> List[Dict[str, Any]]:
        return self.active_traces.get(trace_id, [])

telemetry_collector = TelemetryCollector()
