# Zero-Trust Agent Identity & Service Accounts Module

# 1. Main Agent Backend Orchestrator Service Account
resource "google_service_account" "sa_backend_orchestrator" {
  project      = var.project_id
  account_id   = "sa-logistics-orchestrator"
  display_name = "All Things Logistics - Backend Orchestrator Agent"
  description  = "Service account for the Gemini 3.7 Flash agent backend on Cloud Run"
}

# 2. HS Classification Agent Service Account
resource "google_service_account" "sa_hs_classifier" {
  project      = var.project_id
  account_id   = "sa-hs-classifier"
  display_name = "Agent Identity - HS Classifier"
  description  = "Least-privilege service account for tariff and HS code classification"
}

# 3. Golden Document Generator Agent Service Account
resource "google_service_account" "sa_doc_generator" {
  project      = var.project_id
  account_id   = "sa-doc-generator"
  display_name = "Agent Identity - Golden Document Generator"
  description  = "Service account authorized to record official customs declarations"
}

# IAM Role: Orchestrator BigQuery Data User
resource "google_project_iam_member" "orchestrator_bigquery_user" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  member  = "serviceAccount:${google_service_account.sa_backend_orchestrator.email}"
}

resource "google_project_iam_member" "orchestrator_bigquery_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.sa_backend_orchestrator.email}"
}

resource "google_project_iam_member" "orchestrator_bigquery_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.sa_backend_orchestrator.email}"
}
