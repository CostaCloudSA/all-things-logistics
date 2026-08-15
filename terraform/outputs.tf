# Root Terraform Outputs

output "backend_api_url" {
  description = "Public Cloud Run URL for the Gemini 3.7 Flash Backend API."
  value       = module.cloud_run.backend_url
}

output "flutter_web_url" {
  description = "Public Cloud Run URL for the Flutter Web Client."
  value       = module.cloud_run.frontend_url
}

output "custom_domain_mapping_status" {
  description = "Status of the custom domain mapping for logistics.campabadal.com."
  value       = module.cloud_run.domain_mapping_status
}

output "bigquery_customs_compliance_dataset" {
  description = "BigQuery dataset for customs compliance."
  value       = module.bigquery.customs_compliance_dataset_id
}

output "bigquery_declarations_dataset" {
  description = "BigQuery dataset for shipments and declarations."
  value       = module.bigquery.shipments_declarations_dataset_id
}

output "orchestrator_service_account" {
  description = "Service account email running the agent backend."
  value       = module.iam.orchestrator_service_account_email
}
