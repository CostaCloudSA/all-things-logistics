# All Things Logistics - Root Terraform Configuration
# Google Cloud Platform Infrastructure for Fortified Enterprise Fleet

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Zero-Trust IAM & Agent Identities
module "iam" {
  source      = "./modules/iam"
  project_id  = var.project_id
  environment = var.environment
}

# 2. BigQuery Domain-Driven Data Mesh
module "bigquery" {
  source      = "./modules/bigquery"
  project_id  = var.project_id
  region      = "US" # BigQuery Multi-Region US or regional
  environment = var.environment
}

# 3. Async Manifest Queue (Pub/Sub)
module "pubsub" {
  source      = "./modules/pubsub"
  project_id  = var.project_id
  environment = var.environment
}

# 4. Cloud Run Services (Backend API & Flutter Web Client)
module "cloud_run" {
  source                 = "./modules/cloud_run"
  project_id             = var.project_id
  region                 = var.region
  backend_image          = var.backend_image
  frontend_image         = var.frontend_image
  service_account_email  = module.iam.orchestrator_service_account_email
  domain_name            = var.domain_name
}
