# Deployment Guide - Muscle Exercises API

This guide covers multiple deployment options for your Muscle Exercises API.

## 🐳 Option 1: Docker Deployment (Recommended)

### Prerequisites
- Docker and Docker Compose installed on your server

### Quick Deploy
```bash
# Clone/upload your project to the server
cd muscle_exercises_api

# Run the deployment script
./deploy.sh
```

### Manual Docker Deployment
```bash
# Build and run with Docker Compose
docker-compose up -d --build

# Check logs
docker-compose logs -f

# Stop the service
docker-compose down
```

### Docker Commands
```bash
# View running containers
docker ps

# View logs
docker-compose logs muscle-exercises-api

# Restart service
docker-compose restart

# Update and redeploy
git pull  # or upload new files
docker-compose up -d --build
```

---

## 🖥️ Option 2: Direct Server Deployment

### Prerequisites
- Python 3.8+ installed
- pip package manager

### Step 1: Setup Environment
```bash
# Create project directory
sudo mkdir -p /opt/muscle-exercises-api
cd /opt/muscle-exercises-api

# Upload your project files here
# Copy all files: main.py, models.py, data_loader.py, *.json, gifs/, etc.

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install gunicorn  # for production
```

### Step 2: Test the Application
```bash
# Test run
python main.py

# Or with uvicorn
uvicorn main:app --host 0.0.0.0 --port 8000
```

### Step 3: Production Setup with Gunicorn
```bash
# Create log directory
sudo mkdir -p /var/log/muscle-exercises-api
sudo chown www-data:www-data /var/log/muscle-exercises-api

# Run with Gunicorn
gunicorn -c gunicorn.conf.py main:app
```

---

## 🔧 Option 3: Systemd Service (Production)

### Step 1: Setup Service
```bash
# Copy service file
sudo cp muscle-exercises-api.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable muscle-exercises-api

# Start service
sudo systemctl start muscle-exercises-api

# Check status
sudo systemctl status muscle-exercises-api
```

### Step 2: Service Management
```bash
# Start service
sudo systemctl start muscle-exercises-api

# Stop service
sudo systemctl stop muscle-exercises-api

# Restart service
sudo systemctl restart muscle-exercises-api

# View logs
sudo journalctl -u muscle-exercises-api -f

# Check if service is running
sudo systemctl is-active muscle-exercises-api
```

---

## 🌐 Option 4: Nginx Reverse Proxy (Recommended for Production)

### Step 1: Install Nginx
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install nginx

# CentOS/RHEL
sudo yum install nginx
```

### Step 2: Configure Nginx
```bash
# Copy nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/muscle-exercises-api

# Enable site
sudo ln -s /etc/nginx/sites-available/muscle-exercises-api /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

### Step 3: Update Domain
Edit `/etc/nginx/sites-available/muscle-exercises-api`:
```nginx
server_name your-actual-domain.com;  # Replace with your domain
```

---

## 🔒 SSL/HTTPS Setup (Optional but Recommended)

### Using Let's Encrypt (Free SSL)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal (add to crontab)
0 12 * * * /usr/bin/certbot renew --quiet
```

---

## 🚀 Cloud Deployment Options

### 1. DigitalOcean Droplet
```bash
# Create a droplet with Ubuntu 20.04+
# Follow "Direct Server Deployment" steps above
```

### 2. AWS EC2
```bash
# Launch EC2 instance with Ubuntu AMI
# Configure security groups (port 80, 443, 8000)
# Follow deployment steps above
```

### 3. Google Cloud Platform
```bash
# Create Compute Engine instance
# Configure firewall rules
# Follow deployment steps above
```

### 4. Heroku (Simple but Limited)
Create `Procfile`:
```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

---

## 📊 Monitoring and Maintenance

### Health Checks
```bash
# Check API health
curl http://your-domain.com/
curl http://your-domain.com/stats

# Check specific endpoints
curl http://your-domain.com/exercises?limit=1
```

### Log Monitoring
```bash
# Application logs (if using systemd)
sudo journalctl -u muscle-exercises-api -f

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Docker logs
docker-compose logs -f
```

### Performance Monitoring
```bash
# Check resource usage
htop
df -h
free -h

# Check API response times
curl -w "@curl-format.txt" -o /dev/null -s http://your-domain.com/exercises
```

Create `curl-format.txt`:
```
     time_namelookup:  %{time_namelookup}\n
        time_connect:  %{time_connect}\n
     time_appconnect:  %{time_appconnect}\n
    time_pretransfer:  %{time_pretransfer}\n
       time_redirect:  %{time_redirect}\n
  time_starttransfer:  %{time_starttransfer}\n
                     ----------\n
          time_total:  %{time_total}\n
```

---

## 🔧 Troubleshooting

### Common Issues

1. **Port already in use**
```bash
# Find process using port 8000
sudo lsof -i :8000
# Kill process
sudo kill -9 <PID>
```

2. **Permission denied**
```bash
# Fix file permissions
sudo chown -R www-data:www-data /opt/muscle-exercises-api
sudo chmod -R 755 /opt/muscle-exercises-api
```

3. **Service won't start**
```bash
# Check service status
sudo systemctl status muscle-exercises-api
# Check logs
sudo journalctl -u muscle-exercises-api -n 50
```

4. **Nginx configuration errors**
```bash
# Test nginx config
sudo nginx -t
# Check nginx logs
sudo tail -f /var/log/nginx/error.log
```

### Performance Tuning

1. **Increase worker processes** (edit `gunicorn.conf.py`):
```python
workers = 8  # 2 * CPU cores
```

2. **Enable gzip compression** (add to nginx config):
```nginx
gzip on;
gzip_types text/plain application/json;
```

3. **Add caching headers** for static files:
```nginx
location /gifs/ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

---

## 📋 Deployment Checklist

- [ ] Server setup complete
- [ ] Dependencies installed
- [ ] Application tested locally
- [ ] Production configuration applied
- [ ] Service/container running
- [ ] Nginx configured (if using)
- [ ] SSL certificate installed (if using HTTPS)
- [ ] Firewall configured
- [ ] Health checks passing
- [ ] Monitoring setup
- [ ] Backup strategy in place

---

## 🆘 Support

If you encounter issues:

1. Check the logs first
2. Verify all dependencies are installed
3. Ensure file permissions are correct
4. Test API endpoints manually
5. Check firewall/security group settings

For specific deployment environments, consult the respective platform documentation.
