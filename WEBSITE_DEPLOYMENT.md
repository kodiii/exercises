# Website Deployment Guide

This guide covers deploying your Muscle Exercises API website to showcase your API.

## 🚀 Option 1: GitHub Pages (Recommended - Free)

### **Quick Setup:**
1. **Go to your repository**: https://github.com/kodiii/exercises
2. **Settings** → **Pages**
3. **Source**: Deploy from a branch
4. **Branch**: `main`
5. **Folder**: `/website`
6. **Save**

### **Result:**
Your website will be live at:
```
https://kodiii.github.io/exercises/
```

### **Connect to Your API:**
1. **Get your EasyPanel API URL** (e.g., `https://muscle-exercises-api-abc123.easypanel.host`)
2. **Update the website files**:
   - Edit `website/script.js` line 199
   - Edit `website/demo.html` line 148
   - Replace `[your-easypanel-id]` with your actual EasyPanel URL

### **Custom Domain (Optional):**
1. **Add your domain** to `website/CNAME` file
2. **Configure DNS** to point to GitHub Pages
3. **Enable HTTPS** in repository settings

---

## 🚀 Option 2: Netlify (Alternative - Free)

### **Steps:**
1. **Go to** [netlify.com](https://netlify.com)
2. **New site from Git**
3. **Connect GitHub** repository: `kodiii/exercises`
4. **Build settings**:
   - Build command: (leave empty)
   - Publish directory: `website`
5. **Deploy**

### **Result:**
Your website will be at:
```
https://[random-name].netlify.app
```

---

## 🚀 Option 3: Vercel (Alternative - Free)

### **Steps:**
1. **Go to** [vercel.com](https://vercel.com)
2. **Import Git Repository**
3. **Select**: `kodiii/exercises`
4. **Framework**: Other
5. **Root Directory**: `website`
6. **Deploy**

### **Result:**
Your website will be at:
```
https://[project-name].vercel.app
```

---

## 🚀 Option 4: Separate Repository (If Preferred)

If you want a dedicated repository for the website:

### **Create New Repository:**
1. **Create new repo**: `muscle-exercises-website`
2. **Copy website files** to new repo
3. **Deploy using any of the above methods**

### **Files to Copy:**
```
website/
├── index.html
├── demo.html
├── styles.css
├── script.js
├── README.md
├── _config.yml
└── CNAME
```

---

## 🔧 Configuration

### **API URL Configuration:**

The website automatically detects where it's running and points to the appropriate API:

- **Local development**: `http://localhost:8000`
- **GitHub Pages**: Points to your EasyPanel API
- **Other hosts**: Auto-detects

### **Update API URL:**

To connect your deployed website to your EasyPanel API:

1. **Get your EasyPanel URL** from the dashboard
2. **Update these files**:

**In `website/script.js`** (line ~199):
```javascript
} else if (currentHost === 'kodiii.github.io') {
    // GitHub Pages - point to EasyPanel deployment
    apiBaseInput.value = 'https://your-actual-easypanel-url.easypanel.host';
```

**In `website/demo.html`** (line ~148):
```javascript
} else if (currentHost === 'kodiii.github.io') {
    // GitHub Pages - point to EasyPanel deployment
    return 'https://your-actual-easypanel-url.easypanel.host';
```

3. **Commit and push** the changes

---

## 🌐 Features Included

### **Website Pages:**
- **Main Page** (`index.html`): Complete API documentation
- **Live Demo** (`demo.html`): Real-time API data display
- **Interactive Playground**: Test API endpoints
- **Code Examples**: Multiple programming languages

### **Responsive Design:**
- **Mobile-friendly**: Works on all devices
- **Fast loading**: Optimized performance
- **Modern UI**: Clean, professional design

### **SEO Optimized:**
- **Meta tags**: Social media sharing
- **Structured data**: Search engine friendly
- **Fast loading**: Good Core Web Vitals

---

## 📊 Analytics (Optional)

### **Google Analytics:**
1. **Get tracking ID** from Google Analytics
2. **Update `_config.yml`**:
   ```yaml
   google_analytics: UA-XXXXXXXX-X
   ```

### **GitHub Pages Analytics:**
- **Built-in insights** in repository settings
- **Traffic data** and popular pages

---

## 🔒 CORS Configuration

Your API already has CORS enabled for all origins:
```python
allow_origins=["*"]
```

This allows your website to call the API from any domain.

For production, you might want to restrict this to specific domains:
```python
allow_origins=["https://kodiii.github.io", "https://yourdomain.com"]
```

---

## 🎯 Recommended Approach

**For your use case, I recommend:**

1. **Use GitHub Pages** (Option 1)
   - ✅ Free and automatic
   - ✅ Uses existing repository
   - ✅ Auto-deploys on code changes
   - ✅ Custom domain support

2. **Keep everything in one repository**
   - ✅ Easier maintenance
   - ✅ Single source of truth
   - ✅ Automatic updates

3. **Update API URLs** to point to your EasyPanel deployment

---

## 🚀 Quick Start

**To deploy your website right now:**

1. **Go to**: https://github.com/kodiii/exercises/settings/pages
2. **Source**: Deploy from a branch
3. **Branch**: main, **Folder**: /website
4. **Save**
5. **Wait 2-3 minutes**
6. **Visit**: https://kodiii.github.io/exercises/

**Your website will be live!** 🎉

---

## 🔄 Updates

**When you update your website:**
1. **Edit files** in the `website/` directory
2. **Commit and push** to GitHub
3. **GitHub Pages automatically rebuilds** (2-3 minutes)
4. **Changes are live**

**No separate deployment needed!**

Your website will showcase your API beautifully and provide an interactive way for users to explore and test your Muscle Exercises API! 🚀
