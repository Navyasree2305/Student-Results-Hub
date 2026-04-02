#!/bin/bash
# deploy.bat - Batch-style deployment script for Linux VM
# Run with: ./deploy.bat

# =============================================================================
# Configuration Section
# =============================================================================
set -e

PROJECT_DIR="/root/spmvv-exam-results"
SERVER_IP=$(hostname -I | awk '{print $1}')

# Database Configuration
set DB_NAME=spmvv_results
set DB_USER=spmvv_user
set DB_PASSWORD=SpmvvDb@2026
set MYSQL_ROOT_PASSWORD=RootPassword@2026

# Admin Configuration
set ADMIN_USERNAME=admin
set ADMIN_PASSWORD=SpmvvExamResults

# =============================================================================
# Main Deployment
# =============================================================================

echo "==============================================================================="
echo "                    SPMVV Exam Results - Batch Deployment"
echo "==============================================================================="
echo ""
echo "Project: SPMVV Exam Results Application"
echo "Location: $PROJECT_DIR"
echo "Server IP: $SERVER_IP"
echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo "==============================================================================="
echo ""

# Step 1: Cleanup
echo "[STEP 1/5] Cleaning up old containers..."
echo "  - Stopping containers..."
docker stop spmvv_backend spmvv_frontend spmvv_db 2>/dev/null || echo "  (No containers to stop)"
echo "  - Removing containers..."
docker rm -f spmvv_backend spmvv_frontend spmvv_db 2>/dev/null || echo "  (No containers to remove)"
echo "  - Killing stale processes..."
pkill -9 -f "npm" 2>/dev/null || echo "  (No npm processes found)"
sleep 2
echo "  ✓ Cleanup completed"
echo ""

# Step 2: Network Setup
echo "[STEP 2/5] Setting up Docker network..."
if docker network inspect spmvv_network >/dev/null 2>&1; then
    echo "  - Network already exists"
else
    echo "  - Creating network..."
    docker network create spmvv_network
fi
echo "  ✓ Network ready"
echo ""

# Step 3: Database Deployment
echo "[STEP 3/5] Deploying database..."
echo "  - Starting MariaDB container..."
docker run -d --name spmvv_db --network spmvv_network -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$DB_NAME" \
  -e MYSQL_USER="$DB_USER" \
  -e MYSQL_PASSWORD="$DB_PASSWORD" \
  -v spmvv_mysql_data:/var/lib/mysql \
  mariadb:10.11

echo "  - Waiting for database initialization (20 seconds)..."
for i in {1..20}; do
    echo -n "."
    sleep 1
done
echo ""
echo "  ✓ Database ready"
echo ""

# Step 4: Backend Deployment
echo "[STEP 4/5] Deploying backend..."
cd "$PROJECT_DIR/backend"

echo "  - Building backend image..."
if docker build -q -t spmvv-backend . 2>/dev/null; then
    echo "  - Build completed (quiet mode)"
else
    echo "  - Building with verbose output..."
    docker build -t spmvv-backend .
fi

echo "  - Starting backend container..."
docker run -d --name spmvv_backend --network spmvv_network -p 8000:8000 \
  -e SECRET_KEY="django-insecure-docker-$(date +%s)" \
  -e DEBUG=True \
  -e ALLOWED_HOSTS="localhost,127.0.0.1,$SERVER_IP" \
  -e DB_ENGINE=django.db.backends.mysql \
  -e DB_NAME="$DB_NAME" \
  -e DB_USER="$DB_USER" \
  -e DB_PASSWORD="$DB_PASSWORD" \
  -e DB_HOST=spmvv_db \
  -e DB_PORT=3306 \
  -e ADMIN_USERNAME="$ADMIN_USERNAME" \
  -e ADMIN_DEFAULT_PASSWORD="$ADMIN_PASSWORD" \
  -e CORS_ALLOWED_ORIGINS="http://localhost:2026,http://$SERVER_IP:2026" \
  spmvv-backend:latest

echo "  - Waiting for migrations (10 seconds)..."
sleep 10
echo "  ✓ Backend ready"
echo ""

# Step 5: Frontend Deployment
echo "[STEP 5/5] Deploying frontend..."
cd "$PROJECT_DIR/frontend"

echo "  - Cleaning stale build processes..."
pkill -9 -f "docker.*build" 2>/dev/null || echo "  (No stale processes)"
sleep 2

echo "  - Building frontend image (may take 5-10 minutes)..."
echo "  - Please wait, this may take a while on slower VMs..."
BUILD_START=$(date +%s)

if timeout 600 docker build -q --build-arg VITE_API_URL="http://$SERVER_IP:8000/api" -t spmvv-frontend . 2>/dev/null; then
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))
    echo "  - Build completed in ${BUILD_TIME} seconds"
else
    echo "  ! First attempt failed, retrying without cache..."
    docker build --no-cache --build-arg VITE_API_URL="http://$SERVER_IP:8000/api" -t spmvv-frontend .
    BUILD_END=$(date +%s)
    BUILD_TIME=$((BUILD_END - BUILD_START))
    echo "  - Build completed in ${BUILD_TIME} seconds (retry)"
fi

echo "  - Starting frontend container..."
docker run -d --name spmvv_frontend --network spmvv_network -p 2026:2026 \
  -e VITE_API_URL="http://$SERVER_IP:8000/api" \
  spmvv-frontend:latest

echo "  - Waiting for startup (5 seconds)..."
sleep 5
echo "  ✓ Frontend ready"
echo ""

# =============================================================================
# Deployment Summary
# =============================================================================

echo "==============================================================================="
echo "                         DEPLOYMENT COMPLETED"
echo "==============================================================================="
echo ""
echo "Container Status:"
echo "--------------------------------------------------------------------------------"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep spmvv || docker ps --format "{{.Names}}: {{.Status}}"
echo ""
echo "==============================================================================="
echo ""
echo "Access Information:"
echo "  Frontend URL:  http://$SERVER_IP:2026"
echo "  Backend API:   http://$SERVER_IP:8000/api"
echo "  Admin Panel:   http://$SERVER_IP:8000/admin"
echo ""
echo "Login Credentials:"
echo "  Username:      $ADMIN_USERNAME"
echo "  Password:      $ADMIN_PASSWORD"
echo ""
echo "==============================================================================="
echo ""
echo "Useful Commands:"
echo "  Check status:  docker ps"
echo "  View logs:     docker logs -f spmvv_frontend"
echo "  Restart:       docker restart spmvv_backend"
echo ""
echo "==============================================================================="
echo "Deployment completed at: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==============================================================================="

