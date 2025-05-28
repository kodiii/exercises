# EasyPanel Deployment Guide

This guide covers deploying your Muscle Exercises API to EasyPanel with optimal configuration.

## 🚀 Quick Deployment

### Method 1: GitHub Integration (Recommended)

1. **Connect GitHub Repository**
   - Go to your EasyPanel dashboard
   - Click "Create Service" → "GitHub"
   - Select repository: `kodiii/exercises`
   - Branch: `main`

2. **Configure Service**
   ```
   Service Name: muscle-exercises-api
   Port: 8000
   Dockerfile: Dockerfile.easypanel (or use default Dockerfile)
   ```

3. **Environment Variables**
   ```
   PYTHONUNBUFFERED=1
   ENVIRONMENT=production
   PORT=8000
   ```

4. **Deploy**
   - Click "Deploy"
   - EasyPanel will build and deploy automatically

### Method 2: Docker Image

1. **Build and Push Image**
   ```bash
   # Build image
   docker build -f Dockerfile.easypanel -t muscle-exercises-api .
   
   # Tag for registry
   docker tag muscle-exercises-api your-registry/muscle-exercises-api:latest
   
   # Push to registry
   docker push your-registry/muscle-exercises-api:latest
   ```

2. **Deploy in EasyPanel**
   - Create service from Docker image
   - Use image: `your-registry/muscle-exercises-api:latest`
   - Configure ports and environment

## ⚙️ EasyPanel Configuration

### Service Settings
```yaml
Name: muscle-exercises-api
Image: Custom (from GitHub)
Port: 8000
Memory: 512MB
CPU: 0.5 cores
```

### Environment Variables
```bash
PYTHONUNBUFFERED=1
ENVIRONMENT=production
PORT=8000
```

### Health Check
```bash
Command: curl -f http://localhost:8000/api
Interval: 30s
Timeout: 10s
Retries: 3
```

### Domain Configuration
```
Custom Domain: your-domain.com
SSL: Auto (Let's Encrypt)
```

## 📁 File Structure for EasyPanel

```
exercises/
├── 🐍 Core Application
│   ├── main.py              # FastAPI app
│   ├── models.py            # Data models
│   ├── data_loader.py       # Data utilities
│   └── requirements.txt     # Dependencies
│
├── 📊 Data Files
│   ├── exercises.json       # Exercise database
│   ├── muscles.json         # Muscle groups
│   ├── bodyParts.json       # Body parts
│   ├── equipments.json      # Equipment types
│   └── gifs/               # Exercise GIFs
│
├── 🌐 Website
│   ├── website/index.html   # Main website
│   ├── website/demo.html    # Live demo
│   ├── website/styles.css   # Styling
│   └── website/script.js    # JavaScript
│
├── 🐳 EasyPanel Config
│   ├── Dockerfile.easypanel # Optimized Dockerfile
│   ├── easypanel-config.json # Service configuration
│   └── EASYPANEL_DEPLOYMENT.md # This guide
│
└── 📖 Documentation
    ├── README.md            # API documentation
    └── DEPLOYMENT.md        # General deployment
```

## 🔧 Optimization for EasyPanel

### Resource Allocation
- **Memory**: 512MB (sufficient for API + website)
- **CPU**: 0.5 cores (handles moderate traffic)
- **Storage**: 1GB (for logs and temporary files)

### Performance Settings
- **Workers**: 2 Gunicorn workers (optimal for 0.5 CPU)
- **Keep-alive**: Enabled for better performance
- **Gzip**: Handled by EasyPanel proxy
- **Caching**: Static files cached automatically

### Security Features
- **Non-root user**: Application runs as `appuser`
- **SSL/TLS**: Auto-configured by EasyPanel
- **Environment isolation**: Container-based deployment
- **Health monitoring**: Automatic restart on failure

## 🌐 Access Your Deployed API

After deployment, your API will be available at:

### EasyPanel Subdomain
```
https://muscle-exercises-api-[random].easypanel.host
```

### Custom Domain (if configured)
```
https://your-domain.com
```

### Available Endpoints
- **Website**: `/website/index.html`
- **API Docs**: `/docs`
- **API Base**: `/exercises`, `/muscles`, etc.
- **Statistics**: `/stats`
- **Health Check**: `/api`

## 📊 Monitoring in EasyPanel

### Built-in Monitoring
- **CPU Usage**: Real-time monitoring
- **Memory Usage**: Memory consumption tracking
- **Network Traffic**: Inbound/outbound data
- **Response Times**: API performance metrics
- **Error Rates**: Failed request tracking

### Logs Access
- **Application Logs**: Available in EasyPanel dashboard
- **Access Logs**: HTTP request logs
- **Error Logs**: Application error tracking
- **Real-time Logs**: Live log streaming

## 🔄 Updates and Maintenance

### Automatic Updates (GitHub Integration)
1. **Push to GitHub**: Code changes trigger rebuild
2. **Auto-deploy**: EasyPanel rebuilds and deploys
3. **Zero-downtime**: Rolling updates with health checks
4. **Rollback**: Easy rollback to previous versions

### Manual Updates
1. **Update Code**: Push changes to GitHub
2. **Trigger Deploy**: Click "Deploy" in EasyPanel
3. **Monitor**: Watch deployment progress
4. **Verify**: Check health and functionality

## 🚨 Troubleshooting

### Common Issues

1. **Build Failures**
   ```bash
   # Check Dockerfile syntax
   docker build -f Dockerfile.easypanel .
   
   # Verify requirements.txt
   pip install -r requirements.txt
   ```

2. **Port Issues**
   ```bash
   # Ensure PORT environment variable is set
   PORT=8000
   
   # Check application binding
   # App should bind to 0.0.0.0:8000
   ```

3. **Health Check Failures**
   ```bash
   # Test health endpoint locally
   curl http://localhost:8000/api
   
   # Check application startup time
   # Increase start_period if needed
   ```

4. **Memory Issues**
   ```bash
   # Monitor memory usage
   # Increase memory allocation if needed
   # Optimize worker count
   ```

### Debug Commands
```bash
# Check service status
curl https://your-app.easypanel.host/api

# Test specific endpoints
curl https://your-app.easypanel.host/exercises?limit=1

# Check website
curl https://your-app.easypanel.host/website/
```

## 🎯 Best Practices for EasyPanel

### 1. Resource Management
- Start with 512MB memory, scale up if needed
- Use 2 workers for 0.5 CPU allocation
- Monitor resource usage regularly

### 2. Environment Configuration
- Use environment variables for configuration
- Keep sensitive data in EasyPanel secrets
- Set appropriate log levels

### 3. Health Monitoring
- Configure proper health checks
- Set reasonable timeout values
- Monitor application metrics

### 4. Domain and SSL
- Use custom domain for production
- Enable auto-SSL with Let's Encrypt
- Configure proper DNS records

### 5. Backup Strategy
- Code: GitHub repository
- Data: JSON files in repository
- Configuration: EasyPanel export

## 📈 Scaling Options

### Vertical Scaling
- **Increase Memory**: 512MB → 1GB → 2GB
- **Increase CPU**: 0.5 → 1.0 → 2.0 cores
- **Add Workers**: Scale Gunicorn workers with CPU

### Horizontal Scaling
- **Load Balancer**: EasyPanel built-in load balancing
- **Multiple Instances**: Deploy multiple service instances
- **Database**: Migrate to external database if needed

## 💰 Cost Optimization

### Resource Efficiency
- **Right-sizing**: Start small, scale as needed
- **Monitoring**: Track actual usage vs allocation
- **Optimization**: Optimize code for better performance

### EasyPanel Features
- **Auto-scaling**: Scale based on demand
- **Sleep Mode**: Reduce costs during low usage
- **Resource Monitoring**: Track and optimize usage

## 🎉 Deployment Checklist

- [ ] Repository connected to EasyPanel
- [ ] Environment variables configured
- [ ] Health checks enabled
- [ ] Custom domain configured (optional)
- [ ] SSL certificate enabled
- [ ] Resource allocation optimized
- [ ] Monitoring enabled
- [ ] Backup strategy in place
- [ ] API endpoints tested
- [ ] Website functionality verified

## 🔗 Useful Links

- **EasyPanel Dashboard**: https://easypanel.io
- **GitHub Repository**: https://github.com/kodiii/exercises
- **API Documentation**: https://your-app.easypanel.host/docs
- **Website**: https://your-app.easypanel.host/website/

Your Muscle Exercises API is now optimized for EasyPanel deployment! 🚀
