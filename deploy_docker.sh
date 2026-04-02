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
# Proxy settings - use resolved IP to avoid DNS issues inside Docker build containers
# apt/npm/pip inside containers cannot resolve proxy-wsa.esl.cisco.com; use IP instead
_PROXY_HOST=$(python3 -c "import socket; print(socket.gethostbyname('proxy-wsa.esl.cisco.com'))" 2>/dev/null || echo "")
if [ -n "$_PROXY_HOST" ]; then
  APT_PROXY="http://$_PROXY_HOST:80"
else
  APT_PROXY="${HTTP_PROXY:-}"
fi
PROXY_ARGS="--build-arg APT_PROXY=$APT_PROXY"

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
echo -e "${BLUE}[1/11] Detecting deployment type...${NC}"

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
    echo -e "${BLUE}[2/11] Backing up existing data...${NC}"
    backup_database && BACKUP_RESULT=0 || BACKUP_RESULT=$?
    
    if [ $BACKUP_RESULT -eq 0 ]; then
        BACKUP_FILE="$BACKUP_DIR/db_backup_$TIMESTAMP.sql"
    fi
    echo ""
else
    echo -e "${BLUE}[2/11] Skipping backup (fresh deployment)${NC}"
    echo ""
fi

# Stop and remove old containers
echo -e "${BLUE}[3/11] Stopping and removing old containers...${NC}"
docker stop spmvv_backend spmvv_frontend spmvv_db spmvv_ollama 2>/dev/null || true
docker rm -f spmvv_backend spmvv_frontend spmvv_db spmvv_ollama 2>/dev/null || true
echo -e "${GREEN}✓ Old containers removed${NC}"
echo ""

# Stop any non-Docker services using ports
echo -e "${BLUE}[4/11] Checking for port conflicts...${NC}"
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
echo -e "${BLUE}[5/11] Creating Docker network...${NC}"
docker network create spmvv_network 2>/dev/null || echo "Network already exists"
echo -e "${GREEN}✓ Network ready${NC}"
echo ""

# Deploy Database
echo -e "${BLUE}[6/11] Deploying database container...${NC}"
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
    echo -e "${BLUE}[7/11] Restoring database from backup...${NC}"
    restore_database "$BACKUP_FILE"
    echo ""
else
    echo -e "${BLUE}[7/11] No restore needed (fresh deployment)${NC}"
    echo ""
fi

# Build and deploy Ollama (AI) container
echo -e "${BLUE}[8/11] Building and deploying Ollama AI container...${NC}"
cd "$PROJECT_DIR/ollama"

# Only build if image does not already exist (model bake takes ~5-10 min)
if docker image inspect spmvv-ollama:latest &>/dev/null; then
    echo -e "${YELLOW}⚠ spmvv-ollama image already exists. Skipping build (model already baked in).${NC}"
    echo -e "${CYAN}  To force a rebuild: docker rmi spmvv-ollama:latest && ./deploy_docker.sh${NC}"
else
    echo -e "${CYAN}Building Ollama image — this pulls qwen2.5:3b (~2 GB) and may take 5-10 minutes...${NC}"
    if ! docker build $PROXY_ARGS -t spmvv-ollama . ; then
        echo -e "${RED}✗ Ollama image build failed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Ollama image built${NC}"
fi

echo -e "${CYAN}Starting Ollama container...${NC}"
docker run -d \
  --name spmvv_ollama \
  --network spmvv_network \
  -p 11434:11434 \
  -e OLLAMA_HOST=0.0.0.0:11434 \
  spmvv-ollama:latest

echo -e "${CYAN}Waiting for Ollama to be ready (15 seconds)...${NC}"
sleep 15
echo -e "${GREEN}✓ Ollama container deployed${NC}"
echo ""

# Build and deploy Backend
echo -e "${BLUE}[9/11] Building and deploying backend...${NC}"
cd "$PROJECT_DIR/backend"

echo -e "${CYAN}Building backend image (this may take 5-10 minutes)...${NC}"
if ! docker build --force-rm $PROXY_ARGS -t spmvv-backend . ; then
    echo -e "✗ Backend build failed"
    exit 1
fi
echo -e "${GREEN}✓ Backend image built${NC}"

echo -e "${CYAN}Starting backend container...${NC}"
docker run -d \
  --name spmvv_backend \
  --network spmvv_network \
  -p 8000:8000 \
  -v spmvv_media_data:/app/media \
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
  -e CORS_EXTRA_ORIGINS="http://$SERVER_IP:2026" \
  -e CSRF_EXTRA_ORIGINS="http://$SERVER_IP:2026" \
  -e OLLAMA_URL="http://spmvv_ollama:11434" \
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
# NOTE: npm registry is unreachable from inside Docker build containers on this
# host, so we build Vite on the host directly and package only the static output
# into a minimal nginx Docker image.
echo -e "${BLUE}[10/11] Building and deploying frontend...${NC}"
cd "$PROJECT_DIR/frontend"

# Stop any stuck builds
pkill -f "docker build.*frontend" 2>/dev/null || true
sleep 2

echo -e "${CYAN}Installing frontend dependencies on host (npm install)...${NC}"
# Only run npm install if node_modules is missing or package.json is newer
if [ ! -d node_modules ] || [ package.json -nt node_modules ]; then
    if ! npm install; then
        echo -e "${RED}✗ npm install failed${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ npm install complete${NC}"
else
    echo -e "${YELLOW}⚠ node_modules up to date, skipping npm install${NC}"
fi

echo -e "${CYAN}Building Vite app on host...${NC}"
echo "VITE_API_URL=/api" > .env
if ! npm run build; then
    echo -e "${RED}✗ Vite build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Vite build complete${NC}"

echo -e "${CYAN}Packaging pre-built frontend into Docker image...${NC}"
# Create a temporary Dockerfile that just wraps the pre-built output
cat > Dockerfile.prebuilt << 'DOCKEREOF'
FROM nginx:alpine
COPY build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
RUN rm -f /etc/nginx/conf.d/default.conf.default
EXPOSE 2026
CMD ["nginx", "-g", "daemon off;"]
DOCKEREOF

if ! docker build -f Dockerfile.prebuilt -t spmvv-frontend .; then
    echo -e "${RED}✗ Frontend Docker image build failed${NC}"
    rm -f Dockerfile.prebuilt
    exit 1
fi
rm -f Dockerfile.prebuilt
echo -e "${GREEN}✓ Frontend image built${NC}"

echo -e "${CYAN}Starting frontend container...${NC}"
docker run -d \
  --name spmvv_frontend \
  --network spmvv_network \
  -p 2026:2026 \
  spmvv-frontend:latest

echo -e "${CYAN}Waiting for frontend to start (10 seconds)...${NC}"
sleep 10
echo -e "${GREEN}✓ Frontend container deployed${NC}"
echo ""

# Configure firewall
echo -e "${BLUE}[11/11] Configuring firewall...${NC}"
if systemctl is-active --quiet firewalld; then
    firewall-cmd --permanent --add-port=8000/tcp 2>/dev/null || true
    firewall-cmd --permanent --add-port=2026/tcp 2>/dev/null || true
    firewall-cmd --permanent --add-port=3306/tcp 2>/dev/null || true
    firewall-cmd --permanent --add-port=11434/tcp 2>/dev/null || true
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
echo -e "  Ollama:   ${CYAN}http://$SERVER_IP:11434${NC}"
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
echo -e "  Stop:     ${CYAN}docker stop spmvv_backend spmvv_frontend spmvv_db spmvv_ollama${NC}"
echo -e "  Start:    ${CYAN}docker start spmvv_db && sleep 10 && docker start spmvv_ollama && sleep 5 && docker start spmvv_backend spmvv_frontend${NC}"
echo -e "  Redeploy: ${CYAN}./deploy_docker.sh${NC}"
echo ""

echo -e "${GREEN}Deployment complete! Access the application at http://$SERVER_IP:2026${NC}"
