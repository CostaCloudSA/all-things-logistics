output "customs_compliance_dataset_id" {
  description = "Dataset ID for customs compliance."
  value       = google_bigquery_dataset.ds_customs_compliance.dataset_id
}

output "shipments_declarations_dataset_id" {
  description = "Dataset ID for shipments and declarations."
  value       = google_bigquery_dataset.ds_shipments_declarations.dataset_id
}

output "mcp_nlp_views_dataset_id" {
  description = "Dataset ID for MCP NLP semantic views."
  value       = google_bigquery_dataset.ds_mcp_nlp_views.dataset_id
}
