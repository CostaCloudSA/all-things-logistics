variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "prod"
}
