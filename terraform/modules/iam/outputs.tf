output "orchestrator_service_account_email" {
  description = "Email of the main backend orchestrator service account."
  value       = google_service_account.sa_backend_orchestrator.email
}

output "hs_classifier_service_account_email" {
  description = "Email of the HS classifier agent service account."
  value       = google_service_account.sa_hs_classifier.email
}

output "doc_generator_service_account_email" {
  description = "Email of the Golden Document generator agent service account."
  value       = google_service_account.sa_doc_generator.email
}
