import os
from pydantic_settings import BaseSettings
from typing import Optional

class Settings(BaseSettings):
    PROJECT_NAME: str = "All Things Logistics - Fortified Enterprise Fleet"
    PROJECT_ID: str = os.getenv("PROJECT_ID", "all-things-logistics-dev")
    ENVIRONMENT: str = os.getenv("ENVIRONMENT", "development")
    GEMINI_API_KEY: Optional[str] = os.getenv("GEMINI_API_KEY", os.getenv("GOOGLE_API_KEY", ""))
    GEMINI_MODEL_NAME: str = "gemini-2.5-flash" # Fallback to standard flash or 3.7 when initialized
    USE_MOCK_BIGQUERY: bool = os.getenv("USE_MOCK_BIGQUERY", "true").lower() == "true"
    HOST: str = "0.0.0.0"
    PORT: int = int(os.getenv("PORT", "8080"))

    class Config:
        env_file = ".env"
        extra = "ignore"

settings = Settings()
