document.addEventListener('DOMContentLoaded', function() {
  const content = document.getElementById('ebook-content');
  const fontSelector = document.getElementById('font-selector');
  const fontSizeSlider = document.getElementById('font-size');
  const fontSizeValue = document.getElementById('font-size-value');

  // Font families
  const fontClasses = ['font-sans', 'font-serif', 'font-mono'];
  
  // Initialize from localStorage or defaults
  let currentFontClass = localStorage.getItem('ebookFontClass') || 'font-sans';
  let currentFontSize = localStorage.getItem('ebookFontSize') || 16;

  // Set initial values
  fontSelector.value = currentFontClass;
  fontSizeSlider.value = currentFontSize;
  fontSizeValue.textContent = `${currentFontSize}px`;
  
  // Apply initial styles
  function applyStyles() {
    // Remove all font classes
    fontClasses.forEach(fontClass => content.classList.remove(fontClass));
    
    // Add current font class
    content.classList.add(currentFontClass);
    
    // Set font size
    content.style.fontSize = `${currentFontSize}px`;
    
    // Save to localStorage
    localStorage.setItem('ebookFontClass', currentFontClass);
    localStorage.setItem('ebookFontSize', currentFontSize);
    
    // Update server if needed
    updateFontPreferencesOnServer();
  }

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

  // Initialize
  applyStyles();

  // Server update function
  function updateFontPreferencesOnServer() {
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