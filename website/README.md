# Muscle Exercises API Website

A beautiful, modern website that showcases the Muscle Exercises API with interactive examples and comprehensive documentation.

## Features

- **Modern Design**: Clean, responsive design with smooth animations
- **Interactive Playground**: Test API endpoints directly from the browser
- **Code Examples**: Multiple programming languages (cURL, JavaScript, Python, PHP)
- **Live Demo**: Real-time data from the API
- **Mobile Responsive**: Works perfectly on all devices
- **Fast Loading**: Optimized for performance

## Files

- `index.html` - Main website page
- `demo.html` - Live demo with real API data
- `styles.css` - Complete styling and responsive design
- `script.js` - Interactive functionality and API playground
- `README.md` - This documentation

## Features Included

### 🎨 Design Elements
- Hero section with animated statistics
- Feature cards with hover effects
- Code syntax highlighting
- Responsive navigation
- Smooth scrolling
- Loading animations

### 🔧 Interactive Components
- **API Playground**: Test endpoints with real responses
- **Code Tabs**: Switch between different programming languages
- **Copy to Clipboard**: Easy code copying
- **Mobile Menu**: Hamburger navigation for mobile
- **Auto-detection**: Automatically detects API URL

### 📱 Responsive Design
- Mobile-first approach
- Tablet and desktop optimized
- Touch-friendly interactions
- Accessible navigation

## Usage

### Local Development
1. Start your API server:
   ```bash
   python main.py
   ```

2. Open the website:
   ```
   http://localhost:8000/website/index.html
   ```

### Production Deployment
The website is automatically served by the FastAPI application at `/website/` when deployed.

## Customization

### Update API URL
The website automatically detects the API URL, but you can customize it in:
- `script.js` - Update the `getApiUrl()` function
- `demo.html` - Update the `getApiUrl()` function

### Styling
- Modify `styles.css` for design changes
- Update color scheme by changing CSS variables
- Add new animations or effects

### Content
- Update `index.html` for content changes
- Modify hero statistics in the HTML
- Add new code examples in the tabs

## Browser Support

- Chrome 60+
- Firefox 60+
- Safari 12+
- Edge 79+

## Dependencies

### External CDNs
- **Prism.js**: Code syntax highlighting
- **Font Awesome**: Icons
- **Google Fonts**: Typography (loaded via CSS)

### No Build Process Required
The website uses vanilla HTML, CSS, and JavaScript - no build tools needed!

## Performance

- **Optimized Images**: Efficient loading
- **Minified CSS**: Fast stylesheet loading
- **Lazy Loading**: Content loads as needed
- **Caching**: Browser caching enabled

## SEO Optimized

- Semantic HTML structure
- Meta tags for social sharing
- Proper heading hierarchy
- Alt text for images
- Fast loading times

## Accessibility

- ARIA labels where needed
- Keyboard navigation support
- High contrast ratios
- Screen reader friendly
- Focus indicators

## API Integration

The website integrates with your Muscle Exercises API to:
- Display real exercise data
- Test endpoints interactively
- Show live statistics
- Demonstrate search functionality

## Deployment Notes

When deployed with the FastAPI application:
- Website accessible at `/website/index.html`
- Root URL (`/`) redirects to the website
- API documentation at `/docs`
- API endpoints at `/exercises`, `/muscles`, etc.

## Future Enhancements

Potential improvements:
- User authentication demo
- Exercise filtering interface
- Workout builder example
- API key management
- Rate limiting demonstration
- WebSocket examples (if added to API)
