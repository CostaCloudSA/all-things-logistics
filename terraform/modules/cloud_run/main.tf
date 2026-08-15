# Cloud Run Serverless Services Module (Backend & Flutter Web)

# 1. Gemini 3.7 Flash Agent Backend Service
resource "google_cloud_run_v2_service" "backend_service" {
  name     = "logistics-backend-api"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = var.service_account_email
    timeout         = "300s" # 5 min timeout for async manifest runs

    containers {
      image = var.backend_image

      resources {
        limits = {
          cpu    = "2"
          memory = "2Gi"
        }
      }

      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }
      env {
        name  = "ENVIRONMENT"
        value = "production"
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
  }
}

# Allow unauthenticated access to the backend API
resource "google_cloud_run_service_iam_member" "backend_public_access" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_v2_service.backend_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# 2. Flutter Web Client Hosting Service
resource "google_cloud_run_v2_service" "frontend_service" {
  name     = "logistics-flutter-web"
  location = var.region
  project  = var.project_id
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = var.frontend_image

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      env {
        name  = "BACKEND_API_URL"
        value = google_cloud_run_v2_service.backend_service.uri
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 5
    }
  }
}

# Allow unauthenticated access to the Flutter Web frontend
resource "google_cloud_run_service_iam_member" "frontend_public_access" {
  location = var.region
  project  = var.project_id
  service  = google_cloud_run_v2_service.frontend_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# 3. Custom Domain Mapping for logistics.campabadal.com
resource "google_cloud_run_domain_mapping" "custom_domain" {
  location = var.region
  project  = var.project_id
  name     = var.domain_name

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.frontend_service.name
  }
}
