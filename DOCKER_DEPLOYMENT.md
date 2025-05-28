# Docker Auto-Deployment Guide

This guide covers the fully automated Docker deployment for the Muscle Exercises API with production-ready configuration.

## 🚀 Quick Start (Auto-Deployment)

### Development Deployment
```bash
# One command deployment
./deploy.sh
```

### Production Deployment
```bash
# Production-grade deployment
./deploy-prod.sh
```

## 📋 What's Included

### 🔧 **Enhanced Features:**
- **Production-ready Dockerfile** with security best practices
- **Multi-service Docker Compose** with API + Nginx
- **Automated health checks** and monitoring
- **Persistent volumes** for logs and data
- **Resource limits** and optimization
- **Security hardening** (non-root user, minimal attack surface)
- **Automatic restart policies**
- **Comprehensive logging**

### 🌐 **Services Deployed:**
1. **FastAPI Application** (Port 8000)
   - Gunicorn with 4 workers
   - Health checks every 30 seconds
   - Automatic restarts
   - Resource limits

2. **Nginx Reverse Proxy** (Port 80/443)
   - Load balancing
   - Static file serving
   - Rate limiting
   - CORS handling
   - SSL/TLS ready

## 🔧 Deployment Options

### Option 1: Development (Default)
```bash
./deploy.sh
```
**Features:**
- Quick setup for development
- Basic monitoring
- Single-service focus
- Easy debugging

**Access:**
- Website: http://localhost:8000/website/
- API: http://localhost:8000
- Docs: http://localhost:8000/docs

### Option 2: Production
```bash
./deploy-prod.sh
```
**Features:**
- Production-grade configuration
- Nginx reverse proxy
- Enhanced security
- Resource management
- Comprehensive logging

**Access:**
- Website: http://localhost
- API: http://localhost/api
- Docs: http://localhost/docs

## 📊 Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   User/Client   │───▶│  Nginx (Port 80) │───▶│ FastAPI (8000)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │                        │
                              ▼                        ▼
                       ┌─────────────┐         ┌─────────────┐
                       │ Static Files│         │   API Data  │
                       │ (Website/   │         │ (JSON Files)│
                       │  GIFs)      │         │             │
                       └─────────────┘         └─────────────┘
```

## 🔍 Health Monitoring

### Automatic Health Checks
- **API Health**: Checks `/api` endpoint every 30 seconds
- **Nginx Health**: Checks `/health` endpoint
- **Container Health**: Docker health checks with retries
- **Service Dependencies**: Nginx waits for API to be healthy

### Manual Health Checks
```bash
# Check all services
docker-compose ps

# Check API health
curl http://localhost:8000/api

# Check Nginx health (production)
curl http://localhost/health

# View logs
docker-compose logs -f
```

## 📁 Directory Structure

```
muscle_exercises_api/
├── 🐳 Docker Configuration
│   ├── Dockerfile              # Production-ready container
│   ├── docker-compose.yml      # Development setup
│   ├── docker-compose.prod.yml # Production setup
│   └── .dockerignore           # Docker ignore rules
│
├── 🌐 Nginx Configuration
│   ├── nginx.conf              # Main Nginx config
│   └── default.conf            # Site configuration
│
├── 🚀 Deployment Scripts
│   ├── deploy.sh               # Development deployment
│   └── deploy-prod.sh          # Production deployment
│
└── 📊 Persistent Data
    ├── logs/                   # Application logs
    ├── gifs/                   # Exercise GIFs
    └── website/                # Static website files
```

## 🔧 Configuration

### Environment Variables
```bash
# API Configuration
PYTHONUNBUFFERED=1
ENVIRONMENT=production
WORKERS=4
PORT=8000

# Docker Configuration
COMPOSE_PROJECT_NAME=muscle-exercises-api
```

### Resource Limits (Production)
```yaml
# API Container
limits:
  cpus: '2.0'
  memory: 1G
reservations:
  cpus: '0.5'
  memory: 512M

# Nginx Container
limits:
  cpus: '1.0'
  memory: 512M
reservations:
  cpus: '0.25'
  memory: 128M
```

## 🔒 Security Features

### Container Security
- **Non-root user**: Application runs as `appuser`
- **Minimal base image**: Python slim image
- **Read-only volumes**: GIFs mounted as read-only
- **Resource limits**: CPU and memory constraints
- **Health checks**: Automatic failure detection

### Network Security
- **Rate limiting**: 10 requests/second with burst
- **CORS configuration**: Controlled cross-origin access
- **Security headers**: XSS protection, content type sniffing
- **Isolated network**: Custom Docker network

## 📈 Performance Optimization

### Application Performance
- **Gunicorn workers**: 4 worker processes
- **Keep-alive connections**: Nginx upstream keep-alive
- **Static file caching**: 1-year cache for assets
- **Gzip compression**: Enabled for text content

### Resource Management
- **Memory limits**: Prevents container memory leaks
- **CPU limits**: Ensures fair resource sharing
- **Log rotation**: Prevents disk space issues
- **Volume persistence**: Data survives container restarts

## 🛠️ Management Commands

### Basic Operations
```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### Production Operations
```bash
# Production deployment
./deploy-prod.sh

# Production logs
docker-compose -f docker-compose.prod.yml logs -f

# Production status
docker-compose -f docker-compose.prod.yml ps

# Update production
./deploy-prod.sh
```

### Maintenance
```bash
# Clean up old images
docker system prune -f

# Update images
docker-compose pull
docker-compose up -d --build

# Backup volumes
docker run --rm -v muscle_exercises_api_logs:/data -v $(pwd):/backup alpine tar czf /backup/logs-backup.tar.gz -C /data .
```

## 🚨 Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Find process using port
   lsof -i :8000
   # Kill process
   kill -9 <PID>
   ```

2. **Container Won't Start**
   ```bash
   # Check logs
   docker-compose logs <service-name>
   # Rebuild container
   docker-compose up -d --build
   ```

3. **Health Check Failing**
   ```bash
   # Check API directly
   curl -v http://localhost:8000/api
   # Check container health
   docker inspect <container-id>
   ```

4. **Permission Issues**
   ```bash
   # Fix file permissions
   sudo chown -R $USER:$USER .
   chmod +x deploy.sh deploy-prod.sh
   ```

### Log Analysis
```bash
# API logs
docker-compose logs muscle-exercises-api

# Nginx logs
docker-compose logs nginx

# All logs with timestamps
docker-compose logs -t

# Follow logs in real-time
docker-compose logs -f --tail=100
```

## 🌐 Production Deployment

### Prerequisites
- Docker and Docker Compose installed
- Ports 80 and 8000 available
- Sufficient disk space (2GB recommended)
- Domain name configured (for public access)

### SSL/HTTPS Setup
1. Obtain SSL certificates (Let's Encrypt recommended)
2. Place certificates in `./ssl/` directory
3. Update Nginx configuration
4. Restart services

### Domain Configuration
1. Update `nginx/default.conf`
2. Replace `localhost` with your domain
3. Configure DNS records
4. Restart Nginx

## 📊 Monitoring and Alerts

### Built-in Monitoring
- Docker health checks
- Nginx access logs
- API error logs
- Resource usage monitoring

### Optional Monitoring Stack
Uncomment in `docker-compose.prod.yml`:
- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards
- **AlertManager**: Alert notifications

## 🔄 Updates and Maintenance

### Regular Updates
```bash
# Pull latest code
git pull origin main

# Redeploy
./deploy-prod.sh

# Verify deployment
curl http://localhost/api
```

### Backup Strategy
- **Code**: Git repository
- **Logs**: Regular volume backups
- **Configuration**: Version controlled
- **Data**: JSON files in repository

## 🎯 Next Steps

1. **Configure SSL** for HTTPS
2. **Set up monitoring** with Prometheus/Grafana
3. **Configure alerts** for downtime
4. **Set up CI/CD** with GitHub Actions
5. **Scale horizontally** with load balancers
6. **Add caching** with Redis
7. **Implement authentication** if needed

Your Muscle Exercises API is now production-ready with full automation! 🚀
