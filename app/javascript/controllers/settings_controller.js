// app/javascript/controllers/settings_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["themeToggle", "fontSize"]
  static values = { userId: Number }

  connect() {
    console.log("Settings controller connected")
    this.loadSettings()
  }

  loadSettings() {
    // Load theme
    const themeValue = this.element.dataset.userTheme || '0'
    document.documentElement.classList.toggle('dark', themeValue === '1')
    
    // Load font size
    const fontSize = this.element.dataset.userFontSize || '14'
    this.applyFontSize(fontSize)
    if (this.hasFontSizeTarget) {
      this.fontSizeTarget.value = fontSize
    }
  }

  toggleTheme(event) {
    const themeValue = event.currentTarget.dataset.themeValue
    document.documentElement.classList.toggle('dark', themeValue === '1')
    this.saveSetting('theme', themeValue)
    console.log("toggled")
  }

  changeFontSize(event) {
    const fontSize = event.currentTarget.value
    this.applyFontSize(fontSize)
    this.saveSetting('font_size', fontSize)
  }

  applyFontSize(fontSize) {
    // Tailwind-specific classes for reference (not used here, just for documentation)
    // text-xs: 12px, sm:14px, base:16px, lg:18px, xl:20px, 2xl:24px
    document.documentElement.style.fontSize = `${fontSize}px`
  }

  async saveSetting(field, value) {
    try {
      const response = await fetch(`/users/${this.userIdValue}/update_setting`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({ field: field, value: value })
      })
      
      const result = await response.json()
      if (!response.ok) throw new Error(result.error)
      console.log(`${field} updated successfully`)
    } catch (error) {
      console.error('Error saving setting:', error)
    }
  }
}