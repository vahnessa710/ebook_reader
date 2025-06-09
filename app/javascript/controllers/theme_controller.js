// app/javascript/controllers/theme_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["themeToggle"]
  static values = { initialTheme: String }

  connect() {
    console.log("Theme controller connected");
    const savedTheme = localStorage.getItem('theme') ||
                       this.initialThemeValue ||
                      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
    console.log("Initial theme:", savedTheme);
    this.setTheme(savedTheme);
  }

  toggle(event) {
    event.preventDefault();
    const theme = event.currentTarget.dataset.theme;
    console.log("Toggle clicked, theme:", theme);
    this.setTheme(theme);
  }

  setTheme(theme) {
    console.log("Setting theme:", theme);
    
    // Update the HTML element's class
    const htmlElement = document.documentElement;
    if (theme === 'dark') {
      htmlElement.classList.add('dark');
    } else {
      htmlElement.classList.remove('dark');
    }
    
    localStorage.setItem('theme', theme);
    this.updateToggleButtons(theme);
    
    if (window.currentUser) {
      // Convert to integer before sending to server
      const themeValue = theme === 'dark' ? 1 : 0;
      this.saveThemeToServer(themeValue);
    }
  }

  updateToggleButtons(theme) {
    this.themeToggleTargets.forEach(button => {
      const isActive = button.dataset.theme === theme;
      
      // Remove all classes first
      button.classList.remove('bg-blue-500', 'text-white', 'bg-gray-200', 'dark:bg-gray-700', 'text-gray-700', 'dark:text-gray-300');
      
      // Add appropriate classes
      if (isActive) {
        button.classList.add('bg-blue-500', 'text-white');
      } else {
        button.classList.add('bg-gray-200', 'dark:bg-gray-700', 'text-gray-700', 'dark:text-gray-300');
      }
    });
  }

  saveThemeToServer(themeValue) {
    fetch(`/users/${window.currentUser.id}/update_theme`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify({ theme: themeValue })
    }).catch(error => console.error('Error:', error));
  }
}