# ==============================================================================
# Campabadal Global Logistics - Automated Google Cloud Run Deployment Script
# Target Project: logistics-hackathon (979851188322)
# Production Domain: logistics.campabadal.com
# ==============================================================================

$ErrorActionPreference = "Stop"
$PROJECT_ID = "logistics-hackathon"
$REGION = "us-central1"
$REPO_NAME = "logistics-repo"
$BACKEND_SERVICE = "logistics-backend-api"
$FRONTEND_SERVICE = "logistics-flutter-web"
$DOMAIN_NAME = "logistics.campabadal.com"

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "🚀 CAMPABADAL GLOBAL LOGISTICS - GOOGLE CLOUD RUN DEPLOYMENT" -ForegroundColor Cyan
Write-Host "Project ID: $PROJECT_ID | Region: $REGION" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Set Active GCP Project
Write-Host "`n[1/6] ⚙️ Setting active project to '$PROJECT_ID'..." -ForegroundColor Yellow
gcloud config set project $PROJECT_ID

# 2. Enable Required Cloud APIs
Write-Host "`n[2/6] 🔌 Enabling Google Cloud Services (Run, Cloud Build, Artifact Registry, BigQuery)..." -ForegroundColor Yellow
gcloud services enable `
    run.googleapis.com `
    cloudbuild.googleapis.com `
    artifactregistry.googleapis.com `
    bigquery.googleapis.com `
    iam.googleapis.com

# 3. Create Artifact Registry Repository (if not exists)
Write-Host "`n[3/6] 📦 Checking / Creating Artifact Registry repository '$REPO_NAME'..." -ForegroundColor Yellow
$repoExists = gcloud artifacts repositories list --location=$REGION --filter="name:$REPO_NAME" --format="value(name)"
if (-not $repoExists) {
    gcloud artifacts repositories create $REPO_NAME `
        --repository-format=docker `
        --location=$REGION `
        --description="Campabadal Logistics Container Registry"
    Write-Host "   Created repository $REPO_NAME." -ForegroundColor Green
} else {
    Write-Host "   Repository $REPO_NAME already exists." -ForegroundColor Green
}

# 4. Build & Deploy Backend API
Write-Host "`n[4/6] 🤖 Building & Deploying Backend API (Gemini 3.7 Flash + FastAPI)..." -ForegroundColor Yellow
$BACKEND_IMAGE = "$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/backend:latest"

gcloud builds submit backend --tag $BACKEND_IMAGE

gcloud run deploy $BACKEND_SERVICE `
    --image $BACKEND_IMAGE `
    --region $REGION `
    --allow-unauthenticated `
    --set-env-vars "ENVIRONMENT=production,PROJECT_ID=$PROJECT_ID" `
    --memory 2Gi `
    --cpu 2 `
    --timeout 300

$BACKEND_URL = gcloud run services describe $BACKEND_SERVICE --region $REGION --format="value(status.url)"
Write-Host "   ✅ Backend API live at: $BACKEND_URL" -ForegroundColor Green

# 5. Build & Deploy Flutter Web Client
Write-Host "`n[5/6] 🎨 Building & Deploying Flutter Web Client (NGINX SPA)..." -ForegroundColor Yellow
$FRONTEND_IMAGE = "$REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/frontend:latest"

gcloud builds submit client --tag $FRONTEND_IMAGE --substitutions "_BACKEND_URL=$BACKEND_URL"

gcloud run deploy $FRONTEND_SERVICE `
    --image $FRONTEND_IMAGE `
    --region $REGION `
    --allow-unauthenticated `
    --memory 512Mi `
    --cpu 1

$FRONTEND_URL = gcloud run services describe $FRONTEND_SERVICE --region $REGION --format="value(status.url)"
Write-Host "   ✅ Frontend Web live at: $FRONTEND_URL" -ForegroundColor Green

# 6. Map Custom Domain logistics.campabadal.com
Write-Host "`n[6/6] 🌐 Mapping Custom Domain '$DOMAIN_NAME'..." -ForegroundColor Yellow
try {
    gcloud beta run domain-mappings create `
        --service $FRONTEND_SERVICE `
        --domain $DOMAIN_NAME `
        --region $REGION
} catch {
    Write-Host "   Domain mapping may already exist or require DNS verification." -ForegroundColor Yellow
}

Write-Host "`n=================================================================" -ForegroundColor Green
Write-Host "🎉 DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "• Backend Cloud Run: $BACKEND_URL" -ForegroundColor Green
Write-Host "• Frontend Cloud Run: $FRONTEND_URL" -ForegroundColor Green
Write-Host "• Custom Domain: https://$DOMAIN_NAME" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
