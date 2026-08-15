variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Google Cloud region for Cloud Run deployment."
  type        = string
  default     = "us-central1"
}

variable "backend_image" {
  description = "Container image for the Gemini 3.7 Flash Agent Backend."
  type        = string
}

variable "frontend_image" {
  description = "Container image for the Flutter Web Client."
  type        = string
}

variable "service_account_email" {
  description = "Service account email running the backend container."
  type        = string
}

variable "domain_name" {
  description = "Custom domain for mapping (e.g., logistics.campabadal.com)."
  type        = string
  default     = "logistics.campabadal.com"
}
