// Mobile Navigation
document.addEventListener('DOMContentLoaded', function() {
    const hamburger = document.querySelector('.hamburger');
    const navMenu = document.querySelector('.nav-menu');
    
    if (hamburger && navMenu) {
        hamburger.addEventListener('click', function() {
            hamburger.classList.toggle('active');
            navMenu.classList.toggle('active');
        });
    }
    
    // Close mobile menu when clicking on a link
    document.querySelectorAll('.nav-menu a').forEach(link => {
        link.addEventListener('click', () => {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
        });
    });
});

// Smooth scrolling for anchor links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Tab functionality for code examples
document.addEventListener('DOMContentLoaded', function() {
    const tabButtons = document.querySelectorAll('.tab-button');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', function() {
            const targetTab = this.getAttribute('data-tab');
            
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked button and corresponding content
            this.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });
});

// API Playground functionality
document.addEventListener('DOMContentLoaded', function() {
    const apiBaseInput = document.getElementById('api-base');
    const endpointSelect = document.getElementById('endpoint-select');
    const tryApiButton = document.getElementById('try-api');
    const apiResponse = document.getElementById('api-response');
    const copyButton = document.getElementById('copy-response');
    
    if (tryApiButton) {
        tryApiButton.addEventListener('click', async function() {
            const baseUrl = apiBaseInput.value.trim();
            const endpoint = endpointSelect.value;
            const fullUrl = baseUrl + endpoint;
            
            // Show loading state
            tryApiButton.innerHTML = '<div class="loading"></div> Loading...';
            tryApiButton.disabled = true;
            
            try {
                const response = await fetch(fullUrl);
                const data = await response.json();
                
                // Format and display the response
                const formattedJson = JSON.stringify(data, null, 2);
                apiResponse.innerHTML = `<code class="language-json">${escapeHtml(formattedJson)}</code>`;
                
                // Re-highlight the code
                if (window.Prism) {
                    Prism.highlightElement(apiResponse.querySelector('code'));
                }
                
            } catch (error) {
                apiResponse.innerHTML = `<code class="language-json">{
  "error": "Failed to fetch data",
  "message": "${error.message}",
  "url": "${fullUrl}",
  "suggestion": "Make sure your API is running and the URL is correct"
}</code>`;
            } finally {
                // Reset button state
                tryApiButton.innerHTML = '<i class="fas fa-play"></i> Try API';
                tryApiButton.disabled = false;
            }
        });
    }
    
    // Copy response functionality
    if (copyButton) {
        copyButton.addEventListener('click', function() {
            const responseText = apiResponse.textContent;
            
            navigator.clipboard.writeText(responseText).then(function() {
                // Show success feedback
                const originalText = copyButton.innerHTML;
                copyButton.innerHTML = '<i class="fas fa-check"></i> Copied!';
                copyButton.style.background = '#10b981';
                
                setTimeout(() => {
                    copyButton.innerHTML = originalText;
                    copyButton.style.background = '';
                }, 2000);
            }).catch(function(err) {
                console.error('Failed to copy text: ', err);
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = responseText;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                
                copyButton.innerHTML = '<i class="fas fa-check"></i> Copied!';
                setTimeout(() => {
                    copyButton.innerHTML = '<i class="fas fa-copy"></i> Copy';
                }, 2000);
            });
        });
    }
});

// Utility function to escape HTML
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
}

// Navbar scroll effect
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (window.scrollY > 50) {
        navbar.style.background = 'rgba(255, 255, 255, 0.98)';
        navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
    } else {
        navbar.style.background = 'rgba(255, 255, 255, 0.95)';
        navbar.style.boxShadow = 'none';
    }
});

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation
document.addEventListener('DOMContentLoaded', function() {
    const animatedElements = document.querySelectorAll('.feature, .endpoint-category, .step');
    
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// Auto-detect API URL based on current location
document.addEventListener('DOMContentLoaded', function() {
    const apiBaseInput = document.getElementById('api-base');
    if (apiBaseInput) {
        // Try to detect if we're running locally or on a server
        const currentHost = window.location.hostname;
        const currentProtocol = window.location.protocol;
        
        if (currentHost === 'localhost' || currentHost === '127.0.0.1') {
            apiBaseInput.value = 'http://localhost:8000';
        } else {
            // Assume API is running on the same host but different port or path
            apiBaseInput.value = `${currentProtocol}//${currentHost}:8000`;
        }
    }
});

// Add loading states to buttons
document.querySelectorAll('.btn').forEach(button => {
    button.addEventListener('click', function(e) {
        // Don't add loading state to navigation buttons
        if (this.getAttribute('href') && this.getAttribute('href').startsWith('#')) {
            return;
        }
        
        // Add subtle loading effect for external links
        if (this.getAttribute('href') && !this.getAttribute('href').startsWith('#')) {
            this.style.opacity = '0.7';
            setTimeout(() => {
                this.style.opacity = '1';
            }, 300);
        }
    });
});

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + K to focus on API playground
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        const playground = document.getElementById('playground');
        if (playground) {
            playground.scrollIntoView({ behavior: 'smooth' });
            const apiInput = document.getElementById('api-base');
            if (apiInput) {
                setTimeout(() => apiInput.focus(), 500);
            }
        }
    }
    
    // Escape key to close mobile menu
    if (e.key === 'Escape') {
        const hamburger = document.querySelector('.hamburger');
        const navMenu = document.querySelector('.nav-menu');
        if (hamburger && navMenu) {
            hamburger.classList.remove('active');
            navMenu.classList.remove('active');
        }
    }
});

// Add ripple effect to buttons
document.querySelectorAll('.btn, .tab-button').forEach(button => {
    button.addEventListener('click', function(e) {
        const ripple = document.createElement('span');
        const rect = this.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);
        const x = e.clientX - rect.left - size / 2;
        const y = e.clientY - rect.top - size / 2;
        
        ripple.style.width = ripple.style.height = size + 'px';
        ripple.style.left = x + 'px';
        ripple.style.top = y + 'px';
        ripple.classList.add('ripple');
        
        this.appendChild(ripple);
        
        setTimeout(() => {
            ripple.remove();
        }, 600);
    });
});

// Add CSS for ripple effect
const style = document.createElement('style');
style.textContent = `
    .btn, .tab-button {
        position: relative;
        overflow: hidden;
    }
    
    .ripple {
        position: absolute;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.3);
        transform: scale(0);
        animation: ripple-animation 0.6s linear;
        pointer-events: none;
    }
    
    @keyframes ripple-animation {
        to {
            transform: scale(4);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
