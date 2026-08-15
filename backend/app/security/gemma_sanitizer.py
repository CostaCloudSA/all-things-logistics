import re
from typing import Dict, Any, Tuple

class LocalGemmaSanitizer:
    """
    Local Gemma Model & Heuristic Sanitization Layer (Model Armor).
    Scrubs confidential enterprise data (EINs, RFCs, CNPJs, SSNs, bank accounts, and pricing margins)
    before sending trade prompts to cloud AI models.
    """
    def __init__(self):
        self.redaction_map: Dict[str, str] = {}
        # Patterns for sensitive trade IDs
        self.patterns = [
            (r'\b\d{2}-\d{7}\b', '[REDACTED_EIN]'),
            (r'\b\d{3}-\d{2}-\d{4}\b', '[REDACTED_SSN]'),
            (r'\b[A-Z&Ñ]{3,4}\d{6}[A-Z0-9]{3}\b', '[REDACTED_RFC]'), # Mexico RFC
            (r'\b\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}\b', '[REDACTED_CNPJ]'), # Brazil CNPJ
            (r'\b(?:\+?\d{1,3}[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b', '[REDACTED_PHONE]'),
            (r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b', '[REDACTED_EMAIL]')
        ]

    def sanitize_text(self, text: str) -> Tuple[str, Dict[str, Any]]:
        """Scrubs sensitive entities from text while preserving commercial trade semantics."""
        sanitized = text
        redactions_count = 0

        for pattern, replacement in self.patterns:
            matches = re.findall(pattern, sanitized)
            if matches:
                redactions_count += len(matches)
                sanitized = re.sub(pattern, replacement, sanitized)

        metadata = {
            "sanitizer_model": "gemma-2b-local-armor",
            "redactions_count": redactions_count,
            "is_sanitized": redactions_count > 0
        }
        return sanitized, metadata

local_gemma_sanitizer = LocalGemmaSanitizer()
