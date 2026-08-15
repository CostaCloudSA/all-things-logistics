output "backend_url" {
  description = "The primary Cloud Run URL for the Gemini 3.7 Flash backend API."
  value       = google_cloud_run_v2_service.backend_service.uri
}

output "frontend_url" {
  description = "The primary Cloud Run URL for the Flutter Web client."
  value       = google_cloud_run_v2_service.frontend_service.uri
}

output "domain_mapping_status" {
  description = "DNS records configuration status for custom domain mapping."
  value       = google_cloud_run_domain_mapping.custom_domain.status
}
