// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Add this to your application.js or a stimulus controller
// function highlightAndScroll(text) {
//   const content = document.getElementById('content');
//   const searchTerm = '<%= @search_term %>';
  
//   // First remove any existing highlights
//   const highlights = content.querySelectorAll('.search-highlight');
//   highlights.forEach(highlight => {
//     highlight.outerHTML = highlight.innerHTML;
//   });
  
//   // Highlight all instances
//   if (searchTerm && searchTerm.length > 0) {
//     const regex = new RegExp(searchTerm, 'gi');
//     content.innerHTML = content.innerHTML.replace(regex, match => 
//       `<span class="search-highlight bg-yellow-200 dark:bg-yellow-800">${match}</span>`
//     );
//   }
  
//   // Scroll to the specific line if clicked from results
//   if (text) {
//     const elements = Array.from(content.querySelectorAll('*')).filter(el => 
//       el.textContent.includes(text)
//     );
//     if (elements.length > 0) {
//       elements[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
//     }
//   }
// }