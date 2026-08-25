from typing import Dict, Any, List, Tuple
from app.agents.base import BaseAgent
from app.core.telemetry import OpenTelemetrySpan
from app.core.mock_tariff_db import search_hs_codes, lookup_tariff
from app.models.schemas import SmartChip

class HSClassificationAgent(BaseAgent):
    """
    HS Tariff Classification Agent.
    Resolves trade descriptions to Harmonized System subheadings with confidence scoring.
    Generates Smart Tap Chips when ambiguous subheadings require field clarification.
    """
    def __init__(self):
        super().__init__(
            agent_id="agent-hs-classifier",
            name="HS Classification Agent",
            role="Tariff code classification and confidence scoring",
            model="gemini-3.7-flash"
        )

    def process(self, payload: Dict[str, Any], span: OpenTelemetrySpan) -> Dict[str, Any]:
        raw_description = payload.get("raw_description", "").lower()
        destination_iso = payload.get("destination_iso", "US").upper()
        selected_chips = payload.get("selected_chips", [])

        span.set_attribute("trade.raw_description", raw_description)
        span.set_attribute("trade.destination_iso", destination_iso)

        # 1. Check if user already refined via Smart Chip
        if "chip_chicken_whole" in selected_chips:
            hs_code = "0207.12.00"
            confidence = 0.98
            refined_desc = "Whole frozen chicken (Gallus domesticus)"
            chips = []
        elif "chip_chicken_cuts" in selected_chips or "chip_chicken_breast" in selected_chips:
            hs_code = "0207.14.00" if destination_iso != "MX" else "0207.14.99"
            confidence = 0.98
            refined_desc = "Frozen chicken cuts and offal (boneless breasts/wings)"
            chips = []
        else:
            # 2. Match heuristics or Gemini call
            hs_code, confidence, refined_desc, chips = self._classify_commodity(raw_description, destination_iso)

        span.set_attribute("trade.hs_code", hs_code)
        span.set_attribute("trade.confidence_score", confidence)
        span.set_attribute("trade.smart_chips_count", len(chips))

        tariff_info = lookup_tariff(hs_code, destination_iso)

        return {
            "hs_code": hs_code,
            "confidence": confidence,
            "refined_description": refined_desc,
            "smart_chips": chips,
            "tariff_info": tariff_info
        }

    def _classify_commodity(self, text: str, dest: str) -> Tuple[str, float, str, List[SmartChip]]:
        """Determines HS code, confidence, and contextual Smart Chips."""
        text = text.lower()

        # Poultry handling
        if "chicken" in text or "pollo" in text or "ave" in text or "frango" in text or "poultry" in text:
            if "whole" in text or "entero" in text or "inteiro" in text:
                return "0207.12.00", 0.95, "Whole frozen chicken", []
            elif "cut" in text or "breast" in text or "pechuga" in text or "trozo" in text or "wing" in text or "corte" in text or "thigh" in text or "leg" in text or "muslo" in text:
                code = "0207.14.00" if dest != "MX" else "0207.14.99"
                return code, 0.95, "Frozen chicken cuts & offal", []
            else:
                # Ambiguous! Yield Smart Chips for field clarification
                chips = [
                    SmartChip(id="chip_chicken_whole", label="🍗 Whole Frozen Bird", category="commodity_refinement", value="whole_frozen"),
                    SmartChip(id="chip_chicken_breast", label="🍗 Boneless Breasts", category="commodity_refinement", value="boneless_breasts"),
                    SmartChip(id="chip_chicken_cuts", label="🍗 Cuts & Offal (Wings/Thighs)", category="commodity_refinement", value="cuts_and_offal")
                ]
                return "0207.14.00", 0.90, "Frozen poultry cuts (Legs and thighs)", chips

        # Pineapples / Fruits
        if "pineapple" in text or "piña" in text or "ananas" in text:
            return "0804.30.00", 0.98, "Fresh Golden MD2 Pineapples", []

        # Bananas
        if "banana" in text or "plátano" in text or "banano" in text:
            return "0803.90.00", 0.98, "Fresh Cavendish Bananas", []

        # Coffee handling
        if "coffee" in text or "café" in text:
            if "roasted" in text or "tostado" in text:
                return "0901.21.00", 0.94, "Roasted coffee beans (not decaffeinated)", []
            else:
                chips = [
                    SmartChip(id="chip_coffee_green", label="☕ Green Coffee (Unroasted)", category="commodity_refinement", value="green_beans"),
                    SmartChip(id="chip_coffee_roasted", label="☕ Roasted Beans", category="commodity_refinement", value="roasted_beans")
                ]
                return "0901.11.00", 0.85, "Green coffee beans", chips

        # Avocados
        if "avocado" in text or "aguacate" in text or "palta" in text:
            return "0804.40.00", 0.96, "Fresh Hass Avocados", []

        # Laptops / Electronics
        if "laptop" in text or "computadora" in text or "notebook" in text:
            return "8471.30.01", 0.95, "Portable automatic data processing machine (Laptop)", []

        # Default fallback
        return "9999.99.99", 0.50, f"Unclassified commodity: {text}", [
            SmartChip(id="chip_custom_hs", label="🔍 Review Tariff Schedule", category="commodity_refinement", value="manual_review")
        ]

    def fallback_heuristic(self, prompt: str) -> str:
        return "0207.14.00"

hs_classification_agent = HSClassificationAgent()
