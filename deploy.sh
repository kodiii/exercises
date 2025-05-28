#!/bin/bash

# Muscle Exercises API - Full Auto Deployment Script
# This script handles complete deployment with health checks and monitoring

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
API_PORT=8000
NGINX_PORT=80
MAX_WAIT_TIME=120
HEALTH_CHECK_INTERVAL=5

echo -e "${BLUE}🚀 Muscle Exercises API - Full Auto Deployment${NC}"
echo "=================================================="

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi
print_status "Docker is installed"

if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi
print_status "Docker Compose is installed"

# Check if ports are available
if lsof -Pi :$API_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    print_warning "Port $API_PORT is already in use. Stopping existing services..."
fi

if lsof -Pi :$NGINX_PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    print_warning "Port $NGINX_PORT is already in use. This might conflict with Nginx."
fi

# Create necessary directories
echo -e "${BLUE}📁 Creating necessary directories...${NC}"
mkdir -p nginx logs
print_status "Directories created"

# Stop and remove existing containers
echo -e "${BLUE}🛑 Stopping existing containers...${NC}"
docker-compose down --remove-orphans 2>/dev/null || true
print_status "Existing containers stopped"

# Clean up old images (optional)
echo -e "${BLUE}🧹 Cleaning up old images...${NC}"
docker system prune -f >/dev/null 2>&1 || true
print_status "Cleanup completed"

# Build and start services
echo -e "${BLUE}🔨 Building and starting services...${NC}"
docker-compose up -d --build

if [ $? -eq 0 ]; then
    print_status "Services started successfully"
else
    print_error "Failed to start services"
    echo "Check logs with: docker-compose logs"
    exit 1
fi

# Wait for services to be healthy
echo -e "${BLUE}⏳ Waiting for services to be healthy...${NC}"
wait_time=0

while [ $wait_time -lt $MAX_WAIT_TIME ]; do
    # Check API health
    if curl -f http://localhost:$API_PORT/api >/dev/null 2>&1; then
        print_status "API is healthy"
        break
    fi

    echo -n "."
    sleep $HEALTH_CHECK_INTERVAL
    wait_time=$((wait_time + HEALTH_CHECK_INTERVAL))
done

if [ $wait_time -ge $MAX_WAIT_TIME ]; then
    print_error "Services failed to start within $MAX_WAIT_TIME seconds"
    echo "Checking logs..."
    docker-compose logs --tail=20
    exit 1
fi

# Verify all endpoints
echo -e "${BLUE}🔍 Verifying API endpoints...${NC}"

endpoints=(
    "/api"
    "/exercises?limit=1"
    "/muscles"
    "/bodyparts"
    "/equipments"
    "/stats"
)

for endpoint in "${endpoints[@]}"; do
    if curl -f "http://localhost:$API_PORT$endpoint" >/dev/null 2>&1; then
        print_status "Endpoint $endpoint is working"
    else
        print_warning "Endpoint $endpoint might have issues"
    fi
done

# Check Nginx (if enabled)
if curl -f http://localhost:$NGINX_PORT/health >/dev/null 2>&1; then
    print_status "Nginx reverse proxy is working"
    NGINX_ENABLED=true
else
    print_warning "Nginx reverse proxy is not responding (this is optional)"
    NGINX_ENABLED=false
fi

# Display deployment summary
echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo "=================================================="
echo -e "${BLUE}📋 Service Information:${NC}"
echo ""

if [ "$NGINX_ENABLED" = true ]; then
    echo -e "${GREEN}🌐 Website:${NC}           http://localhost"
    echo -e "${GREEN}📖 API Documentation:${NC} http://localhost/docs"
    echo -e "${GREEN}🔗 API Base URL:${NC}      http://localhost/api"
    echo -e "${GREEN}📊 API Statistics:${NC}    http://localhost/stats"
    echo -e "${GREEN}🎬 Exercise GIFs:${NC}     http://localhost/gifs/"
else
    echo -e "${GREEN}🌐 Website:${NC}           http://localhost:$API_PORT/website/"
    echo -e "${GREEN}📖 API Documentation:${NC} http://localhost:$API_PORT/docs"
    echo -e "${GREEN}🔗 API Base URL:${NC}      http://localhost:$API_PORT"
    echo -e "${GREEN}📊 API Statistics:${NC}    http://localhost:$API_PORT/stats"
    echo -e "${GREEN}🎬 Exercise GIFs:${NC}     http://localhost:$API_PORT/gifs/"
fi

echo ""
echo -e "${BLUE}🔧 Management Commands:${NC}"
echo "  View logs:           docker-compose logs -f"
echo "  Stop services:       docker-compose down"
echo "  Restart services:    docker-compose restart"
echo "  Update deployment:   ./deploy.sh"
echo ""

# Show container status
echo -e "${BLUE}📊 Container Status:${NC}"
docker-compose ps

echo ""
echo -e "${GREEN}✨ Your Muscle Exercises API is now live and ready to use!${NC}"

# Optional: Open browser (uncomment if desired)
# if command -v open &> /dev/null; then
#     open http://localhost
# elif command -v xdg-open &> /dev/null; then
#     xdg-open http://localhost
# fi
