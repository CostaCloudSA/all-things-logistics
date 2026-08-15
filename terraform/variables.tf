# Terraform Variables for All Things Logistics
# Google Cloud & Enterprise Infrastructure Configuration

variable "project_id" {
  description = "The Google Cloud Project ID where resources will be provisioned."
  type        = string
  default     = "all-things-logistics-dev"
}

variable "region" {
  description = "Primary Google Cloud Region for compute and storage."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)."
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Custom domain name for the live hosted web application."
  type        = string
  default     = "logistics.campabadal.com"
}

variable "backend_image" {
  description = "Container image URI for the Gemini 3.7 Flash Agent Backend."
  type        = string
  default     = "gcr.io/cloudrun/hello" # Placeholder until first CI/CD build
}

variable "frontend_image" {
  description = "Container image URI for the Flutter Web Client."
  type        = string
  default     = "gcr.io/cloudrun/hello" # Placeholder until first CI/CD build
}

variable "gemini_api_key" {
  description = "Gemini API key stored securely in Google Secret Manager."
  type        = string
  sensitive   = true
  default     = ""
}
