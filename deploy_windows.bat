@echo off
REM =============================================================================
REM SPMVV Exam Results - Windows Docker Desktop Deployment
REM =============================================================================
REM Run this script on Windows machine with Docker Desktop installed
REM The application will be accessible at http://localhost:2026
REM =============================================================================

setlocal enabledelayedexpansion

REM Configuration
set PROJECT_NAME=spmvv
set DB_NAME=spmvv_results
set DB_USER=spmvv_user
set DB_PASSWORD=SpmvvDb@2026
set MYSQL_ROOT_PASSWORD=RootPassword@2026
set ADMIN_USERNAME=admin
set ADMIN_PASSWORD=SpmvvExamResults
set SERVER_IP=localhost

REM Get project directory (where this batch file is located)
set PROJECT_DIR=%~dp0
set PROJECT_DIR=%PROJECT_DIR:~0,-1%

echo ===============================================================================
echo                    SPMVV Exam Results - Windows Deployment
echo ===============================================================================
echo.
echo Project: SPMVV Exam Results Application
echo Location: %PROJECT_DIR%
echo Server: %SERVER_IP%
echo Time: %date% %time%
echo.
echo ===============================================================================
echo.

REM Check if Docker is running
echo [CHECK] Verifying Docker Desktop...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)
echo   - Docker Desktop is running
echo.

REM Step 1: Cleanup
echo [STEP 1/5] Cleaning up old containers...
echo   - Stopping containers...
docker stop %PROJECT_NAME%_backend %PROJECT_NAME%_frontend %PROJECT_NAME%_db 2>nul
echo   - Removing containers...
docker rm -f %PROJECT_NAME%_backend %PROJECT_NAME%_frontend %PROJECT_NAME%_db 2>nul
echo   - Cleanup completed
echo.

REM Step 2: Network
echo [STEP 2/5] Setting up Docker network...
docker network inspect %PROJECT_NAME%_network >nul 2>&1
if errorlevel 1 (
    echo   - Creating network...
    docker network create %PROJECT_NAME%_network
) else (
    echo   - Network already exists
)
echo   - Network ready
echo.

REM Step 3: Database
echo [STEP 3/5] Deploying database...
echo   - Starting MariaDB container...
docker run -d --name %PROJECT_NAME%_db ^
  --network %PROJECT_NAME%_network ^
  -e MYSQL_ROOT_PASSWORD=%MYSQL_ROOT_PASSWORD% ^
  -e MYSQL_DATABASE=%DB_NAME% ^
  -e MYSQL_USER=%DB_USER% ^
  -e MYSQL_PASSWORD=%DB_PASSWORD% ^
  -v %PROJECT_NAME%_mysql_data:/var/lib/mysql ^
  -p 3306:3306 ^
  mariadb:10.11

if errorlevel 1 (
    echo ERROR: Failed to start database container
    pause
    exit /b 1
)

echo   - Waiting for database initialization (30 seconds)...
timeout /t 30 /nobreak >nul
echo   - Database ready
echo.

REM Step 4: Backend
echo [STEP 4/5] Deploying backend...
cd /d "%PROJECT_DIR%\backend"

if not exist "Dockerfile" (
    echo ERROR: Backend Dockerfile not found!
    echo Expected location: %PROJECT_DIR%\backend\Dockerfile
    pause
    exit /b 1
)

echo   - Building backend image...
docker build -t %PROJECT_NAME%-backend . 2>nul
if errorlevel 1 (
    echo   - Build failed, retrying with verbose output...
    docker build -t %PROJECT_NAME%-backend .
    if errorlevel 1 (
        echo ERROR: Backend build failed!
        pause
        exit /b 1
    )
)

echo   - Starting backend container...
docker run -d --name %PROJECT_NAME%_backend ^
  --network %PROJECT_NAME%_network ^
  -e SECRET_KEY=django-insecure-docker-windows ^
  -e DEBUG=True ^
  -e ALLOWED_HOSTS=localhost,127.0.0.1 ^
  -e DB_ENGINE=django.db.backends.mysql ^
  -e DB_NAME=%DB_NAME% ^
  -e DB_USER=%DB_USER% ^
  -e DB_PASSWORD=%DB_PASSWORD% ^
  -e DB_HOST=%PROJECT_NAME%_db ^
  -e DB_PORT=3306 ^
  -e ADMIN_USERNAME=%ADMIN_USERNAME% ^
  -e ADMIN_DEFAULT_PASSWORD=%ADMIN_PASSWORD% ^
  -e CORS_ALLOWED_ORIGINS=http://localhost:2026,http://127.0.0.1:2026 ^
  -p 8000:8000 ^
  %PROJECT_NAME%-backend:latest

if errorlevel 1 (
    echo ERROR: Failed to start backend container
    pause
    exit /b 1
)

echo   - Waiting for migrations (15 seconds)...
timeout /t 15 /nobreak >nul
echo   - Backend ready
echo.

REM Step 5: Frontend
echo [STEP 5/5] Deploying frontend...
cd /d "%PROJECT_DIR%\frontend"

if not exist "Dockerfile" (
    echo ERROR: Frontend Dockerfile not found!
    echo Expected location: %PROJECT_DIR%\frontend\Dockerfile
    pause
    exit /b 1
)

echo   - Building frontend image (this may take 5-10 minutes)...
echo   - Please be patient, npm install downloads many packages...

set BUILD_START_TIME=%time%

docker build --build-arg VITE_API_URL=http://localhost:8000/api -t %PROJECT_NAME%-frontend . 2>nul
if errorlevel 1 (
    echo   - First attempt failed, retrying without cache...
    docker build --no-cache --build-arg VITE_API_URL=http://localhost:8000/api -t %PROJECT_NAME%-frontend .
    if errorlevel 1 (
        echo ERROR: Frontend build failed!
        echo.
        echo Common issues:
        echo   - Not enough memory allocated to Docker Desktop
        echo   - Network issues downloading npm packages
        echo   - Missing dependencies in package.json
        echo.
        echo Try:
        echo   1. Increase Docker Desktop memory to 4GB or more
        echo   2. Check your internet connection
        echo   3. Run: docker system prune -a
        pause
        exit /b 1
    )
)

echo   - Starting frontend container...
docker run -d --name %PROJECT_NAME%_frontend ^
  --network %PROJECT_NAME%_network ^
  -e VITE_API_URL=http://localhost:8000/api ^
  -p 2026:2026 ^
  %PROJECT_NAME%-frontend:latest

if errorlevel 1 (
    echo ERROR: Failed to start frontend container
    pause
    exit /b 1
)

echo   - Waiting for startup (5 seconds)...
timeout /t 5 /nobreak >nul
echo   - Frontend ready
echo.

REM Deployment Summary
echo ===============================================================================
echo                         DEPLOYMENT COMPLETED
echo ===============================================================================
echo.
echo Container Status:
echo --------------------------------------------------------------------------------
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | findstr %PROJECT_NAME%
echo.
echo ===============================================================================
echo.
echo Access Information:
echo   Frontend URL:  http://localhost:2026
echo   Backend API:   http://localhost:8000/api
echo   Admin Panel:   http://localhost:8000/admin
echo.
echo Login Credentials:
echo   Username:      %ADMIN_USERNAME%
echo   Password:      %ADMIN_PASSWORD%
echo.
echo ===============================================================================
echo.
echo Useful Commands:
echo   Check status:  docker ps
echo   View logs:     docker logs -f %PROJECT_NAME%_frontend
echo   Stop all:      docker stop %PROJECT_NAME%_db %PROJECT_NAME%_backend %PROJECT_NAME%_frontend
echo   Restart:       docker restart %PROJECT_NAME%_backend
echo.
echo ===============================================================================
echo Deployment completed at: %date% %time%
echo ===============================================================================
echo.

pause
