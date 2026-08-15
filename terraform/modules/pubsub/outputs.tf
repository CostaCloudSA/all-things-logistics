output "topic_name" {
  description = "Pub/Sub topic for async manifest jobs."
  value       = google_pubsub_topic.manifest_jobs_topic.name
}

output "subscription_name" {
  description = "Pub/Sub subscription for manifest processing workers."
  value       = google_pubsub_subscription.manifest_jobs_sub.name
}
