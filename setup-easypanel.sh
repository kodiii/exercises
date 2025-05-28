#!/bin/bash

# EasyPanel Setup Script for Muscle Exercises API
# This script prepares your repository for optimal EasyPanel deployment

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setting up Muscle Exercises API for EasyPanel${NC}"
echo "=================================================="

# Check if we're in the right directory
if [ ! -f "main.py" ]; then
    echo -e "${YELLOW}⚠️  Please run this script from the project root directory${NC}"
    exit 1
fi

echo -e "${BLUE}📋 EasyPanel Deployment Configuration${NC}"
echo ""
echo -e "${GREEN}✅ Repository Structure:${NC}"
echo "  - FastAPI application ready"
echo "  - Website files included"
echo "  - Exercise data and GIFs present"
echo "  - EasyPanel-optimized Dockerfile created"
echo ""

echo -e "${GREEN}✅ Recommended EasyPanel Settings:${NC}"
echo ""
echo -e "${BLUE}Service Configuration:${NC}"
echo "  Name: muscle-exercises-api"
echo "  Port: 8000"
echo "  Memory: 512MB"
echo "  CPU: 0.5 cores"
echo ""

echo -e "${BLUE}Environment Variables:${NC}"
echo "  PYTHONUNBUFFERED=1"
echo "  ENVIRONMENT=production"
echo "  PORT=8000"
echo ""

echo -e "${BLUE}Health Check:${NC}"
echo "  Command: curl -f http://localhost:8000/api"
echo "  Interval: 30s"
echo "  Timeout: 10s"
echo "  Retries: 3"
echo ""

echo -e "${GREEN}✅ Deployment Options:${NC}"
echo ""
echo -e "${BLUE}Option 1: GitHub Integration (Recommended)${NC}"
echo "  1. Connect your GitHub repository to EasyPanel"
echo "  2. Select repository: kodiii/exercises"
echo "  3. Use branch: main"
echo "  4. Configure settings above"
echo "  5. Deploy!"
echo ""

echo -e "${BLUE}Option 2: Docker Image${NC}"
echo "  1. Build: docker build -f Dockerfile.easypanel -t muscle-exercises-api ."
echo "  2. Push to your registry"
echo "  3. Deploy from image in EasyPanel"
echo ""

echo -e "${GREEN}✅ After Deployment:${NC}"
echo ""
echo "Your API will be available at:"
echo "  🌐 Website: https://your-app.easypanel.host/website/"
echo "  📖 API Docs: https://your-app.easypanel.host/docs"
echo "  🔗 API: https://your-app.easypanel.host/exercises"
echo "  📊 Stats: https://your-app.easypanel.host/stats"
echo ""

echo -e "${GREEN}✅ Features Included:${NC}"
echo "  - 500+ exercises with detailed information"
echo "  - Interactive website with API playground"
echo "  - Auto-generated API documentation"
echo "  - Search and filtering capabilities"
echo "  - Exercise GIFs and demonstrations"
echo "  - Health monitoring and auto-restart"
echo "  - Production-ready configuration"
echo ""

echo -e "${BLUE}📖 Documentation:${NC}"
echo "  - Complete guide: EASYPANEL_DEPLOYMENT.md"
echo "  - API documentation: README.md"
echo "  - General deployment: DEPLOYMENT.md"
echo ""

echo -e "${GREEN}🎉 Your repository is ready for EasyPanel deployment!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Go to your EasyPanel dashboard"
echo "2. Create a new service from GitHub"
echo "3. Select this repository (kodiii/exercises)"
echo "4. Configure the settings shown above"
echo "5. Deploy and enjoy your API!"
echo ""
echo -e "${BLUE}💡 Tip: Use the GitHub integration for automatic updates${NC}"
