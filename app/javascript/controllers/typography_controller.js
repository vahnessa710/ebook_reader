import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  
  // Font size options in order
  static fontSizes = [
    'text-xs',    // 12px
    'text-sm',    // 14px
    'text-base',  // 16px
    'text-lg',    // 18px
    'text-xl',    // 20px
    'text-2xl'    // 24px
  ]

  connect() {
    console.log("Typography controller connected xxx");
    this.setInitialFontFamily()
    this.setInitialFontSize()
  }
  
  setInitialFontFamily() {
    const savedFont = localStorage.getItem('fontFamily') || 'font-sans'
    this.applyFontFamily(savedFont)
    document.getElementById('font-family-selector').value = savedFont
    console.log("set font to:", savedFont)
  }
  
  setInitialFontSize() {
    const savedSize = localStorage.getItem('fontSize') || 'text-base'
    this.applyFontSize(savedSize)
    document.getElementById('font-size-selector').value = savedSize
  }
  
  changeFontFamily(event) {
    const fontClass = event.target.value
    this.applyFontFamily(fontClass)
    localStorage.setItem('fontFamily', fontClass)
  }
  
  changeFontSize(event) {
    const sizeClass = event.target.value
    this.applyFontSize(sizeClass)
    localStorage.setItem('fontSize', sizeClass)
  }
  
  applyFontFamily(fontClass) {
    this.contentTarget.classList.remove('font-sans', 'font-serif', 'font-mono')
    this.contentTarget.classList.add(fontClass)
  }
  
  applyFontSize(sizeClass) {
    // Remove all possible text size classes
    this.contentTarget.classList.remove(...this.constructor.fontSizes)
    // Add the selected size class
    this.contentTarget.classList.add(sizeClass)
  }
}