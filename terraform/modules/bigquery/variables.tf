variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The location/region for BigQuery datasets."
  type        = string
  default     = "US"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "prod"
}
