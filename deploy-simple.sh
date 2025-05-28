#!/bin/bash

# Simple Auto-Deployment Script for Muscle Exercises API
# This script deploys just the API without Nginx for simplicity

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Muscle Exercises API - Simple Auto Deployment${NC}"
echo "=================================================="

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi
echo -e "${GREEN}✅ Docker is installed${NC}"

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi
echo -e "${GREEN}✅ Docker Compose is installed${NC}"

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker daemon is not running. Please start Docker first.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Docker daemon is running${NC}"

# Stop existing containers
echo -e "${BLUE}🛑 Stopping existing containers...${NC}"
docker-compose -f docker-compose.simple.yml down --remove-orphans 2>/dev/null || true
echo -e "${GREEN}✅ Existing containers stopped${NC}"

# Build and start the application
echo -e "${BLUE}🔨 Building and starting the application...${NC}"
docker-compose -f docker-compose.simple.yml up -d --build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Application started successfully${NC}"
else
    echo -e "${RED}❌ Failed to start application${NC}"
    echo "Check logs with: docker-compose -f docker-compose.simple.yml logs"
    exit 1
fi

# Wait for the application to start
echo -e "${BLUE}⏳ Waiting for the application to start...${NC}"
sleep 20

# Check if the application is running
echo -e "${BLUE}🔍 Checking application health...${NC}"
max_attempts=12
attempt=1

while [ $attempt -le $max_attempts ]; do
    if curl -f http://localhost:8000/api >/dev/null 2>&1; then
        echo -e "${GREEN}✅ API is running successfully!${NC}"
        break
    else
        echo -n "."
        sleep 5
        attempt=$((attempt + 1))
    fi
done

if [ $attempt -gt $max_attempts ]; then
    echo -e "${RED}❌ API failed to start within 60 seconds${NC}"
    echo "Check logs with: docker-compose -f docker-compose.simple.yml logs"
    exit 1
fi

# Verify endpoints
echo -e "${BLUE}🔍 Verifying API endpoints...${NC}"
endpoints=(
    "/api"
    "/exercises?limit=1"
    "/stats"
)

for endpoint in "${endpoints[@]}"; do
    if curl -f "http://localhost:8000$endpoint" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Endpoint $endpoint is working${NC}"
    else
        echo -e "${YELLOW}⚠️  Endpoint $endpoint might have issues${NC}"
    fi
done

# Display success information
echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo "=================================================="
echo -e "${BLUE}📋 Service Information:${NC}"
echo ""
echo -e "${GREEN}🌐 Website:${NC}           http://localhost:8000/website/index.html"
echo -e "${GREEN}📖 API Documentation:${NC} http://localhost:8000/docs"
echo -e "${GREEN}🔗 API Base URL:${NC}      http://localhost:8000"
echo -e "${GREEN}📊 API Statistics:${NC}    http://localhost:8000/stats"
echo -e "${GREEN}🎬 Exercise GIFs:${NC}     http://localhost:8000/gifs/"
echo ""
echo -e "${BLUE}🔧 Management Commands:${NC}"
echo "  View logs:           docker-compose -f docker-compose.simple.yml logs -f"
echo "  Stop services:       docker-compose -f docker-compose.simple.yml down"
echo "  Restart services:    docker-compose -f docker-compose.simple.yml restart"
echo "  Update deployment:   ./deploy-simple.sh"
echo ""

# Show container status
echo -e "${BLUE}📊 Container Status:${NC}"
docker-compose -f docker-compose.simple.yml ps

echo ""
echo -e "${GREEN}✨ Your Muscle Exercises API is now live and ready to use!${NC}"

# Optional: Open browser
if command -v open &> /dev/null; then
    echo -e "${BLUE}🌐 Opening website in browser...${NC}"
    open http://localhost:8000/website/index.html
elif command -v xdg-open &> /dev/null; then
    echo -e "${BLUE}🌐 Opening website in browser...${NC}"
    xdg-open http://localhost:8000/website/index.html
fi
