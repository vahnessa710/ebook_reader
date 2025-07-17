// app/assets/javascripts/chapters.js
document.addEventListener('DOMContentLoaded', function() {
  const content = document.getElementById('ebook-content');
  const fontSelector = document.getElementById('font-selector');
  const fontSizeSlider = document.getElementById('font-size');
  const fontSizeValue = document.getElementById('font-size-value');

  // Initialize from server-side values embedded in the HTML
  let currentFontClass = '<%= @font_class %>';
  let currentFontSize = '<%= current_user.font_size %>';

  // Set initial slider display
  fontSizeValue.textContent = `${currentFontSize}px`;

  // Event listeners
  fontSelector.addEventListener('change', function() {
    currentFontClass = this.value;
    applyStyles();
  });

  fontSizeSlider.addEventListener('input', function() {
    currentFontSize = this.value;
    fontSizeValue.textContent = `${currentFontSize}px`;
    applyStyles();
  });

  function applyStyles() {
    // Remove all possible font classes
    ['font-sans', 'font-serif', 'font-mono'].forEach(cls => {
      content.classList.remove(cls);
    });
    
    // Add current font class
    content.classList.add(currentFontClass);
    
    // Set font size
    content.style.fontSize = `${currentFontSize}px`;
    
    // Save preferences
    savePreferences();
  }

  function savePreferences() {
    // Local storage
    localStorage.setItem('ebookFontClass', currentFontClass);
    localStorage.setItem('ebookFontSize', currentFontSize);
    
    // Server sync
    fetch('/font_preferences', {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ 
        font_class: currentFontClass,
        font_size: currentFontSize
      })
    });
  }
});