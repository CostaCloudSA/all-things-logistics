from typing import Dict, Any, List, Optional, Tuple
from app.core.mock_tariff_db import (
    lookup_tariff,
    lookup_bridge_formula,
    lookup_non_resident_withholding,
    screen_sanctions_entity
)

class ModelArmorGuardrails:
    """
    Model Armor Enforcement Layer:
    1. Enforces Deterministic Grounding: Validates that tariff rates, axle math, and tax withholdings match BigQuery truth.
    2. Confidence Gating: Flags classifications with confidence < 0.80 for user Smart Chip selection.
    3. Circuit Breaker: Prevents runaway agent loops (max cycles = 2).
    4. Compliance Shield: Deterministic screening against sanctions watchlists and bridge formula limits.
    """
    CONFIDENCE_THRESHOLD = 0.80
    MAX_REFLECTION_CYCLES = 2

    @staticmethod
    def verify_tariff_grounding(hs_code: str, destination_iso: str, claimed_duty_rate: float) -> Tuple[bool, float, str]:
        """Verifies tariff rate against deterministic database rather than LLM hallucination."""
        official_data = lookup_tariff(hs_code, destination_iso)
        if not official_data:
            return True, claimed_duty_rate, "UNVERIFIED_TARIFF_TABLE_ENTRY"

        official_rate = official_data["ad_valorem_rate"]
        if abs(official_rate - claimed_duty_rate) > 0.001:
            # Deterministic override! Replace LLM hallucination with official BigQuery rate
            return False, official_rate, f"OVERRIDE_HALLUCINATED_DUTY: Model claimed {claimed_duty_rate*100}%, official BigQuery is {official_rate*100}%"

        return True, official_rate, "GROUNDED_VERIFIED"

    @staticmethod
    def verify_bridge_formula_grounding(
        steer_lbs: float,
        drive_tandem_lbs: float,
        trailer_tandem_lbs: float,
        jurisdiction: str = "US_FEDERAL_TITLE_23"
    ) -> Dict[str, Any]:
        """Audits axle weights deterministically against statutory bridge formula limits."""
        limits = lookup_bridge_formula(jurisdiction) or lookup_bridge_formula("US_FEDERAL_TITLE_23")
        gross_lbs = steer_lbs + drive_tandem_lbs + trailer_tandem_lbs

        violations = []
        if steer_lbs > limits["max_steer_axle_lbs"]:
            violations.append(f"Steer axle ({steer_lbs:,.0f} lbs) exceeds statutory limit ({limits['max_steer_axle_lbs']:,.0f} lbs)")
        if drive_tandem_lbs > limits["max_drive_tandem_lbs"]:
            violations.append(f"Drive tandem ({drive_tandem_lbs:,.0f} lbs) exceeds statutory limit ({limits['max_drive_tandem_lbs']:,.0f} lbs)")
        if trailer_tandem_lbs > limits["max_trailer_tandem_lbs"]:
            violations.append(f"Trailer tandem ({trailer_tandem_lbs:,.0f} lbs) exceeds statutory limit ({limits['max_trailer_tandem_lbs']:,.0f} lbs)")
        if gross_lbs > limits["max_gross_weight_lbs"]:
            violations.append(f"Gross vehicle weight ({gross_lbs:,.0f} lbs) exceeds maximum allowable ({limits['max_gross_weight_lbs']:,.0f} lbs)")

        is_compliant = len(violations) == 0
        return {
            "is_compliant": is_compliant,
            "gross_weight_lbs": gross_lbs,
            "steer_lbs": steer_lbs,
            "drive_tandem_lbs": drive_tandem_lbs,
            "trailer_tandem_lbs": trailer_tandem_lbs,
            "jurisdiction": jurisdiction,
            "regulatory_statute": limits["regulatory_statute"],
            "violations": violations,
            "recommended_action": "PERMITTED_TO_ROLL" if is_compliant else "REBALANCE_CARGO_TANDEM_AXLES"
        }

    @staticmethod
    def verify_non_resident_withholding_grounding(country_iso: str, claimed_withholding_pct: float) -> Tuple[bool, float, str]:
        """Validates foreign income tax withholding rates at source against statutory laws."""
        official_tax = lookup_non_resident_withholding(country_iso)
        if not official_tax:
            return True, claimed_withholding_pct, "NO_WITHHOLDING_RECORDED"

        official_rate = official_tax["statutory_withholding_rate"]
        if abs(official_rate - claimed_withholding_pct) > 0.001:
            return False, official_rate, f"OVERRIDE_STATUTORY_TAX: Claimed {claimed_withholding_pct*100}%, official statutory withholding is {official_rate*100}% under {official_tax['legal_basis']}"

        return True, official_rate, f"GROUNDED_VERIFIED: {official_tax['legal_basis']}"

    @staticmethod
    def verify_sanctions_grounding(parties: List[str]) -> List[Dict[str, Any]]:
        """Screens all transaction parties against OFAC SDN, BIS Entity List, and UN Sanctions."""
        hits = []
        for party in parties:
            match = screen_sanctions_entity(party)
            if match:
                hits.append(match)
        return hits

    @staticmethod
    def evaluate_confidence(confidence: float) -> Tuple[bool, str]:
        if confidence < ModelArmorGuardrails.CONFIDENCE_THRESHOLD:
            return False, f"CONFIDENCE_BELOW_THRESHOLD_{ModelArmorGuardrails.CONFIDENCE_THRESHOLD}: Human in the loop required"
        return True, "CONFIDENCE_ACCEPTABLE"

model_armor = ModelArmorGuardrails()
