import os
import json
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional
from app.config import settings
from app.core.telemetry import OpenTelemetrySpan, telemetry_collector

class BaseAgent(ABC):
    """Abstract Base Agent for the Fortified Enterprise Fleet."""
    def __init__(self, agent_id: str, name: str, role: str, model: str = "gemini-3.7-flash"):
        self.agent_id = agent_id
        self.name = name
        self.role = role
        self.model = model
        self.client = None
        self._init_gemini_client()

    def _init_gemini_client(self):
        """Initializes Gemini client if API key is present."""
        if settings.GEMINI_API_KEY:
            try:
                from google import genai
                self.client = genai.Client(api_key=settings.GEMINI_API_KEY)
            except Exception as e:
                print(f"Warning: Could not initialize Google GenAI client for {self.name}: {e}")

    def call_gemini(self, system_prompt: str, user_prompt: str, response_schema: Optional[Any] = None) -> str:
        """Calls Gemini API with fallback to deterministic heuristics if key is not configured."""
        if not self.client:
            return self.fallback_heuristic(user_prompt)

        try:
            from google.genai import types
            config = types.GenerateContentConfig(
                system_instruction=system_prompt,
                temperature=0.1
            )
            response = self.client.models.generate_content(
                model=self.model,
                contents=user_prompt,
                config=config
            )
            return response.text
        except Exception as e:
            print(f"Gemini API execution error in {self.name}: {e}. Falling back to heuristic.")
            return self.fallback_heuristic(user_prompt)

    @abstractmethod
    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        """Execute agent workflow within OpenTelemetry span."""
        pass

    @abstractmethod
    def fallback_heuristic(self, prompt: str) -> str:
        """Deterministic offline heuristic rule engine."""
        pass
