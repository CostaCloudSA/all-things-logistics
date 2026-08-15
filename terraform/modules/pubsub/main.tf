# Async Manifest Processing Queue Module (Pub/Sub)

resource "google_pubsub_topic" "manifest_jobs_topic" {
  name    = "customs-manifest-processing-jobs"
  project = var.project_id

  labels = {
    domain      = "async-manifests"
    environment = var.environment
  }
}

resource "google_pubsub_subscription" "manifest_jobs_sub" {
  name    = "customs-manifest-processing-sub"
  topic   = google_pubsub_topic.manifest_jobs_topic.name
  project = var.project_id

  ack_deadline_seconds = 300 # 5 min ack deadline for long regulatory audits

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}
