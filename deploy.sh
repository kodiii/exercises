#!/bin/bash

# Muscle Exercises API Deployment Script

echo "🚀 Deploying Muscle Exercises API..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Build and start the application
echo "🔨 Building and starting the application..."
docker-compose up -d --build

# Wait for the application to start
echo "⏳ Waiting for the application to start..."
sleep 10

# Check if the application is running
if curl -f http://localhost:8000/ > /dev/null 2>&1; then
    echo "✅ API is running successfully!"
    echo "📖 API Documentation: http://localhost:8000/docs"
    echo "🌐 API Base URL: http://localhost:8000"
    echo "📊 API Stats: http://localhost:8000/stats"
else
    echo "❌ API failed to start. Check logs with: docker-compose logs"
    exit 1
fi

echo "🎉 Deployment completed!"
