# SPMVV Deployment Script for Windows Docker Desktop
# This script works from any directory where you placed the code

Write-Host "========================================"
Write-Host "SPMVV Deployment for Windows"
Write-Host "========================================"
Write-Host ""

# Get current directory (where this script is located)
$PROJECT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Project directory: $PROJECT_DIR"
Write-Host ""

# Configuration
$SERVER_IP = "localhost"

# Database credentials
$DB_NAME = "spmvv_results"
$DB_USER = "spmvv_user"
$DB_PASSWORD = "SpmvvDb@2026"
$MYSQL_ROOT_PASSWORD = "RootPassword@2026"

# Admin credentials
$ADMIN_USERNAME = "admin"
$ADMIN_PASSWORD = "SpmvvExamResults"

Write-Host "[1/6] Cleanup old containers..."
docker stop spmvv_backend spmvv_frontend spmvv_db spmvv_ollama 2>$null
docker rm -f spmvv_backend spmvv_frontend spmvv_db spmvv_ollama 2>$null
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[2/6] Creating network..."
docker network create spmvv_network 2>$null

Write-Host ""
Write-Host "[3/6] Starting database..."
docker run -d `
  --name spmvv_db `
  --network spmvv_network `
  -p 3306:3306 `
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD `
  -e MYSQL_DATABASE=$DB_NAME `
  -e MYSQL_USER=$DB_USER `
  -e MYSQL_PASSWORD=$DB_PASSWORD `
  -v spmvv_mysql_data:/var/lib/mysql `
  mariadb:10.11

Write-Host "  Waiting 20 seconds for database..."
Start-Sleep -Seconds 20

Write-Host ""
Write-Host "[4/6] Building and starting Ollama AI..."
Set-Location "$PROJECT_DIR\ollama"

if (!(Test-Path "Dockerfile")) {
    Write-Host "  ERROR: ollama/Dockerfile not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$ollamaExists = docker image inspect spmvv-ollama:latest 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Ollama image already exists, skipping build."
} else {
    Write-Host "  Building Ollama image (pulls qwen2.5:3b ~2GB, may take 5-10 min)..."
    docker build -t spmvv-ollama .
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Ollama build failed!" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

docker run -d `
  --name spmvv_ollama `
  --network spmvv_network `
  -p 11434:11434 `
  -e OLLAMA_HOST=0.0.0.0:11434 `
  spmvv-ollama:latest

Write-Host "  Waiting 15 seconds for Ollama..."
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "[5/6] Building and starting backend..."
Set-Location "$PROJECT_DIR\backend"

if (!(Test-Path "Dockerfile")) {
    Write-Host "  ERROR: backend/Dockerfile not found!" -ForegroundColor Red
    Write-Host "  Make sure you are running this script from the project root directory."
    Read-Host "Press Enter to exit"
    exit 1
}

docker build -t spmvv-backend .
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Backend build failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

docker run -d `
  --name spmvv_backend `
  --network spmvv_network `
  -p 8000:8000 `
  -e SECRET_KEY="django-insecure-windows" `
  -e DEBUG=True `
  -e ALLOWED_HOSTS="localhost,127.0.0.1,$SERVER_IP" `
  -e DB_ENGINE=django.db.backends.mysql `
  -e DB_NAME=$DB_NAME `
  -e DB_USER=$DB_USER `
  -e DB_PASSWORD=$DB_PASSWORD `
  -e DB_HOST=spmvv_db `
  -e DB_PORT=3306 `
  -e ADMIN_USERNAME=$ADMIN_USERNAME `
  -e ADMIN_DEFAULT_PASSWORD=$ADMIN_PASSWORD `
  -e "CORS_EXTRA_ORIGINS=http://localhost:2026,http://127.0.0.1:2026" `
  -e "CSRF_EXTRA_ORIGINS=http://localhost:2026,http://127.0.0.1:2026" `
  -e OLLAMA_URL=http://spmvv_ollama:11434 `
  spmvv-backend:latest

Write-Host "  Waiting 10 seconds for backend..."
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "[6/6] Building and starting frontend..."
Set-Location "$PROJECT_DIR\frontend"

if (!(Test-Path "Dockerfile")) {
    Write-Host "  ERROR: frontend/Dockerfile not found!" -ForegroundColor Red
    Write-Host "  Make sure you are running this script from the project root directory."
    Read-Host "Press Enter to exit"
    exit 1
}

docker build -t spmvv-frontend .
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Frontend build failed! Retrying with no-cache..." -ForegroundColor Yellow
    docker build --no-cache -t spmvv-frontend .
}

docker run -d `
  --name spmvv_frontend `
  --network spmvv_network `
  -p 2026:2026 `
  spmvv-frontend:latest

Write-Host "  Waiting 5 seconds..."
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "========================================"
Write-Host "  DEPLOYMENT COMPLETE" -ForegroundColor Green
Write-Host "========================================"
Write-Host ""
docker ps
Write-Host ""
Write-Host "Frontend: http://localhost:2026" -ForegroundColor Cyan
Write-Host "Backend:  http://localhost:8000/api" -ForegroundColor Cyan
Write-Host ""
Write-Host "Login: $ADMIN_USERNAME / $ADMIN_PASSWORD" -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to exit"
