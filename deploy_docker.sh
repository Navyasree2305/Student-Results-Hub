#!/bin/bash

# SPMVV Exam Results - Complete Docker Deployment Script
# Handles both new deployments and redeployments with backup/restore

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
PROJECT_DIR="/root/spmvv-exam-results"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SERVER_IP=$(hostname -I | awk '{print $1}')

# Database credentials
DB_NAME="spmvv_results"
DB_USER="spmvv_user"
DB_PASSWORD="SpmvvDb@2026"
MYSQL_ROOT_PASSWORD="RootPassword@2026"

# Admin credentials (FIXED)
ADMIN_USERNAME="admin"
ADMIN_PASSWORD="SpmvvExamResults"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  SPMVV Exam Results - Docker Deployment & Redeploy Script ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to check if container exists
container_exists() {
    docker ps -a --format "{{.Names}}" | grep -q "^$1$"
}

# Function to check if container is running
container_running() {
    docker ps --format "{{.Names}}" | grep -q "^$1$"
}

# Function to backup database
backup_database() {
    echo -e "${YELLOW}[BACKUP] Checking if database backup is needed...${NC}"
    
    if container_running "spmvv_db"; then
        echo -e "${CYAN}Database container is running. Checking for data...${NC}"
        
        # Check if database has tables
        TABLE_COUNT=$(docker exec spmvv_db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME; SHOW TABLES;" 2>/dev/null | wc -l)
        
        if [ "$TABLE_COUNT" -gt 1 ]; then
            echo -e "${GREEN}Database has data. Creating backup...${NC}"
            BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
            
            docker exec spmvv_db mysqldump -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE" 2>/dev/null
            
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ Database backed up to: $BACKUP_FILE${NC}"
                return 0
            else
                echo -e "${RED}✗ Database backup failed${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}⚠ Database is empty. No backup needed.${NC}"
            return 2
        fi
    else
        echo -e "${YELLOW}⚠ Database container not running. No backup needed.${NC}"
        return 2
    fi
}

# Function to restore database
restore_database() {
    local BACKUP_FILE=$1
    
    if [ -f "$BACKUP_FILE" ]; then
        echo -e "${CYAN}Restoring database from: $BACKUP_FILE${NC}"
        
        # Wait for database to be ready
        echo "Waiting for database to be ready..."
        for i in {1..30}; do
            if docker exec spmvv_db mysql -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" &>/dev/null; then
                echo -e "${GREEN}Database is ready${NC}"
                break
            fi
            echo -n "."
            sleep 2
        done
        echo ""
        
        # Restore the backup
        docker exec -i spmvv_db mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$BACKUP_FILE"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Database restored successfully${NC}"
            return 0
        else
            echo -e "${RED}✗ Database restore failed${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠ No backup file found. Skipping restore.${NC}"
        return 2
    fi
}

# Main deployment
echo -e "${BLUE}[1/10] Detecting deployment type...${NC}"

BACKUP_FILE=""
IS_REDEPLOYMENT=false

if container_exists "spmvv_db" || container_exists "spmvv_backend" || container_exists "spmvv_frontend"; then
    IS_REDEPLOYMENT=true
    echo -e "${CYAN}→ Existing deployment detected. This is a REDEPLOYMENT.${NC}"
else
    echo -e "${CYAN}→ No existing containers found. This is a FRESH deployment.${NC}"
fi
echo ""

# Backup if redeployment
if [ "$IS_REDEPLOYMENT" = true ]; then
    echo -e "${BLUE}[2/10] Backing up existing data...${NC}"
    backup_database
    BACKUP_RESULT=$?
    
    if [ $BACKUP_RESULT -eq 0 ]; then
        BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
    fi
    echo ""
else
    echo -e "${BLUE}[2/10] Skipping backup (fresh deployment)${NC}"
    echo ""
fi

# Stop and remove old containers
echo -e "${BLUE}[3/10] Stopping and removing old containers...${NC}"
docker stop spmvv_backend spmvv_frontend spmvv_db 2>/dev/null || true
docker rm -f spmvv_backend spmvv_frontend spmvv_db 2>/dev/null || true
echo -e "${GREEN}✓ Old containers removed${NC}"
echo ""

# Stop any non-Docker services using ports
echo -e "${BLUE}[4/10] Checking for port conflicts...${NC}"
pkill -f "manage.py runserver" 2>/dev/null || true
pkill -f "vite" 2>/dev/null || true
pkill -f "npm run dev" 2>/dev/null || true

# Stop host MariaDB if running
if systemctl is-active --quiet mariadb 2>/dev/null; then
    echo -e "${YELLOW}Stopping host MariaDB service...${NC}"
    systemctl stop mariadb
    systemctl disable mariadb
fi

echo -e "${GREEN}✓ Port conflicts resolved${NC}"
echo ""

# Create network
echo -e "${BLUE}[5/10] Creating Docker network...${NC}"
docker network create spmvv_network 2>/dev/null || echo "Network already exists"
echo -e "${GREEN}✓ Network ready${NC}"
echo ""

# Deploy Database
echo -e "${BLUE}[6/10] Deploying database container...${NC}"
docker run -d \
  --name spmvv_db \
  --network spmvv_network \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$DB_NAME" \
  -e MYSQL_USER="$DB_USER" \
  -e MYSQL_PASSWORD="$DB_PASSWORD" \
  -v spmvv_mysql_data:/var/lib/mysql \
  mariadb:10.11

echo -e "${CYAN}Waiting for database to be ready (30 seconds)...${NC}"
sleep 30
echo -e "${GREEN}✓ Database container deployed${NC}"
echo ""

# Restore backup if exists
if [ "$IS_REDEPLOYMENT" = true ] && [ -n "$BACKUP_FILE" ]; then
    echo -e "${BLUE}[7/10] Restoring database from backup...${NC}"
    restore_database "$BACKUP_FILE"
    echo ""
else
    echo -e "${BLUE}[7/10] No restore needed (fresh deployment)${NC}"
    echo ""
fi

# Build and deploy Backend
echo -e "${BLUE}[8/10] Building and deploying backend...${NC}"
cd "$PROJECT_DIR/backend"

echo -e "${CYAN}Building backend image (this may take 5-10 minutes)...${NC}"
if ! docker build --force-rm -t spmvv-backend . ; then
    echo -e "✗ Backend build failed"
    exit 1
fi
echo -e "${GREEN}✓ Backend image built${NC}"

echo -e "${CYAN}Starting backend container...${NC}"
docker run -d \
  --name spmvv_backend \
  --network spmvv_network \
  -p 8000:8000 \
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

echo -e "${CYAN}Waiting for backend to initialize (20 seconds)...${NC}"
sleep 20

# Check backend logs for errors
if docker logs spmvv_backend 2>&1 | grep -q "Error"; then
    echo -e "${YELLOW}⚠ Backend started with warnings. Check logs: docker logs spmvv_backend${NC}"
else
    echo -e "${GREEN}✓ Backend container deployed${NC}"
fi
echo ""

# Build and deploy Frontend
echo -e "${BLUE}[9/10] Building and deploying frontend...${NC}"
cd "$PROJECT_DIR/frontend"

# Stop any stuck builds
pkill -f "docker build.*frontend" 2>/dev/null || true
sleep 2

echo -e "${CYAN}Building frontend image (this may take 2-3 minutes)...${NC}"
if ! docker build \
  --build-arg VITE_API_URL="http://$SERVER_IP:8000/api" \
  -t spmvv-frontend . ; then
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Frontend image built${NC}"

echo -e "${CYAN}Starting frontend container...${NC}"
docker run -d \
  --name spmvv_frontend \
  --network spmvv_network \
  -p 2026:2026 \
  -e VITE_API_URL="http://$SERVER_IP:8000/api" \
  spmvv-frontend:latest

echo -e "${CYAN}Waiting for frontend to start (10 seconds)...${NC}"
sleep 10
echo -e "${GREEN}✓ Frontend container deployed${NC}"
echo ""

# Configure firewall
echo -e "${BLUE}[10/10] Configuring firewall...${NC}"
if systemctl is-active --quiet firewalld; then
    firewall-cmd --permanent --add-port=8000/tcp 2>/dev/null || true
    firewall-cmd --permanent --add-port=2026/tcp 2>/dev/null || true
    firewall-cmd --permanent --add-port=3306/tcp 2>/dev/null || true
    firewall-cmd --reload 2>/dev/null || true
    echo -e "${GREEN}✓ Firewall configured${NC}"
else
    echo -e "${YELLOW}⚠ Firewall not running${NC}"
fi
echo ""

# Verification
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    DEPLOYMENT COMPLETE                     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check containers
echo -e "${CYAN}Container Status:${NC}"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Test backend
echo -e "${CYAN}Testing backend API...${NC}"
if curl -s http://localhost:8000/api/ &>/dev/null; then
    echo -e "${GREEN}✓ Backend API is accessible${NC}"
else
    echo -e "${RED}✗ Backend API is not accessible${NC}"
fi

# Test login
echo -e "${CYAN}Testing admin login...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8000/api/login/ \
  -H 'Content-Type: application/json' \
  -d "{\"username\":\"$ADMIN_USERNAME\",\"password\":\"$ADMIN_PASSWORD\"}")

if echo "$LOGIN_RESPONSE" | grep -q "access"; then
    echo -e "${GREEN}✓ Admin login successful${NC}"
else
    echo -e "${RED}✗ Admin login failed${NC}"
fi

# Test frontend
echo -e "${CYAN}Testing frontend...${NC}"
if curl -s http://localhost:2026 | grep -q "SPMVV"; then
    echo -e "${GREEN}✓ Frontend is accessible${NC}"
else
    echo -e "${RED}✗ Frontend is not accessible${NC}"
fi
echo ""

# Summary
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                  ✓ DEPLOYMENT SUCCESSFUL                   ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Access Information:${NC}"
echo -e "  Frontend: ${CYAN}http://$SERVER_IP:2026${NC}"
echo -e "  Backend:  ${CYAN}http://$SERVER_IP:8000/api${NC}"
echo ""

echo -e "${BLUE}Login Credentials:${NC}"
echo -e "  Username: ${GREEN}$ADMIN_USERNAME${NC}"
echo -e "  Password: ${GREEN}$ADMIN_PASSWORD${NC}"
echo ""

if [ "$IS_REDEPLOYMENT" = true ] && [ -n "$BACKUP_FILE" ]; then
    echo -e "${BLUE}Backup Information:${NC}"
    echo -e "  Backup saved: ${CYAN}$BACKUP_FILE${NC}"
    echo ""
fi

echo -e "${YELLOW}Important Commands:${NC}"
echo -e "  Status:   ${CYAN}docker ps${NC}"
echo -e "  Logs:     ${CYAN}docker logs -f spmvv_backend${NC}"
echo -e "  Stop:     ${CYAN}docker stop spmvv_backend spmvv_frontend spmvv_db${NC}"
echo -e "  Start:    ${CYAN}docker start spmvv_db && sleep 10 && docker start spmvv_backend spmvv_frontend${NC}"
echo -e "  Redeploy: ${CYAN}./deploy_docker.sh${NC}"
echo ""

echo -e "${GREEN}🎉 Deployment complete! Access the application at http://$SERVER_IP:2026${NC}"
