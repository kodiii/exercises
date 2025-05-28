#!/bin/bash

# Production Deployment Script for Muscle Exercises API
# This script deploys the API with production-grade configuration

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Muscle Exercises API - Production Deployment${NC}"
echo "=================================================="

# Check if running as root (recommended for production)
if [[ $EUID -eq 0 ]]; then
   echo -e "${YELLOW}⚠️  Running as root. This is recommended for production deployment.${NC}"
else
   echo -e "${YELLOW}⚠️  Not running as root. Make sure Docker permissions are configured.${NC}"
fi

# Check prerequisites
echo -e "${BLUE}🔍 Checking prerequisites...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed.${NC}"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"

# Create production directories
echo -e "${BLUE}📁 Setting up production directories...${NC}"
mkdir -p nginx logs ssl monitoring
chmod 755 nginx logs
echo -e "${GREEN}✅ Directories created${NC}"

# Stop existing containers
echo -e "${BLUE}🛑 Stopping existing containers...${NC}"
docker-compose -f docker-compose.prod.yml down --remove-orphans 2>/dev/null || true
echo -e "${GREEN}✅ Existing containers stopped${NC}"

# Pull latest images and build
echo -e "${BLUE}🔨 Building production images...${NC}"
docker-compose -f docker-compose.prod.yml build --no-cache
echo -e "${GREEN}✅ Images built successfully${NC}"

# Start services
echo -e "${BLUE}🚀 Starting production services...${NC}"
docker-compose -f docker-compose.prod.yml up -d

# Wait for services to be healthy
echo -e "${BLUE}⏳ Waiting for services to be healthy...${NC}"
sleep 30

# Health checks
echo -e "${BLUE}🔍 Performing health checks...${NC}"

# Check API
if curl -f http://localhost:8000/api >/dev/null 2>&1; then
    echo -e "${GREEN}✅ API is healthy${NC}"
else
    echo -e "${RED}❌ API health check failed${NC}"
    docker-compose -f docker-compose.prod.yml logs muscle-exercises-api
    exit 1
fi

# Check Nginx
if curl -f http://localhost/health >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Nginx is healthy${NC}"
else
    echo -e "${RED}❌ Nginx health check failed${NC}"
    docker-compose -f docker-compose.prod.yml logs nginx
    exit 1
fi

# Security recommendations
echo ""
echo -e "${BLUE}🔒 Security Recommendations:${NC}"
echo "1. Configure SSL certificates in ./ssl/ directory"
echo "2. Update Nginx configuration for your domain"
echo "3. Set up firewall rules (UFW recommended)"
echo "4. Configure log rotation"
echo "5. Set up monitoring and alerting"

# Display production info
echo ""
echo -e "${GREEN}🎉 Production deployment completed!${NC}"
echo "=================================================="
echo -e "${BLUE}📋 Production Services:${NC}"
echo ""
echo -e "${GREEN}🌐 Website:${NC}           http://localhost"
echo -e "${GREEN}📖 API Documentation:${NC} http://localhost/docs"
echo -e "${GREEN}🔗 API Base URL:${NC}      http://localhost/api"
echo -e "${GREEN}📊 API Statistics:${NC}    http://localhost/stats"
echo ""
echo -e "${BLUE}🔧 Management Commands:${NC}"
echo "  View logs:           docker-compose -f docker-compose.prod.yml logs -f"
echo "  Stop services:       docker-compose -f docker-compose.prod.yml down"
echo "  Restart services:    docker-compose -f docker-compose.prod.yml restart"
echo "  Update deployment:   ./deploy-prod.sh"
echo ""

# Show container status
echo -e "${BLUE}📊 Container Status:${NC}"
docker-compose -f docker-compose.prod.yml ps

echo ""
echo -e "${GREEN}✨ Production API is now live!${NC}"
echo -e "${YELLOW}⚠️  Remember to configure SSL and domain settings for public access.${NC}"
