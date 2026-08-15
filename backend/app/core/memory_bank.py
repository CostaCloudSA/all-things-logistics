from typing import Dict, Any, Optional

class MemoryBank:
    """Enterprise Memory Bank: Maintains persistent, cross-session customer profiles and historical trade state."""
    def __init__(self):
        self.sessions: Dict[str, Dict[str, Any]] = {}
        self.importer_profiles: Dict[str, Dict[str, Any]] = {
            "CAMPABADAL_GLOBAL_LOGISTICS": {
                "us_ein": "12-3456789",
                "mx_rfc": "CGL950815AB1",
                "br_cnpj": "12.345.678/0001-90",
                "co_rut": "900123456-7",
                "default_incoterm": "FOB",
                "customs_bond_number": "CB-9948210-US",
                "preferred_us_port": "5201" # Miami, FL
            }
        }

    def get_session(self, session_id: str) -> Dict[str, Any]:
        if session_id not in self.sessions:
            self.sessions[session_id] = {
                "history": [],
                "current_trade": {},
                "active_chips": []
            }
        return self.sessions[session_id]

    def update_session(self, session_id: str, data: Dict[str, Any]):
        session = self.get_session(session_id)
        session.update(data)

    def get_importer_profile(self, company_key: str = "CAMPABADAL_GLOBAL_LOGISTICS") -> Dict[str, Any]:
        return self.importer_profiles.get(company_key, {})

memory_bank = MemoryBank()
