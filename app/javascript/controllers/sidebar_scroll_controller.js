// app/javascript/controllers/sidebar_scroll_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["nav", "link"]
  static values = { 
    currentChapterId: Number,
    restoreScroll: Boolean
  }

  connect() {
    // Restore scroll position if coming from navigation
    if (this.restoreScrollValue) {
      this.restoreScrollPosition()
    }
    
    // Ensure current chapter is visible
    this.scrollToCurrentChapter()
  }

  linkTargetConnected(element) {
    // Add click handler to save scroll position before navigation
    element.addEventListener('click', this.saveScrollPosition.bind(this))
  }

  saveScrollPosition(event) {
    // Save current scroll position to sessionStorage
    const scrollTop = this.navTarget.scrollTop
    sessionStorage.setItem('sidebarScrollPosition', scrollTop.toString())
  }

  restoreScrollPosition() {
    // Restore scroll position from sessionStorage
    const savedScrollTop = sessionStorage.getItem('sidebarScrollPosition')
    if (savedScrollTop) {
      // Use requestAnimationFrame to ensure DOM is ready
      requestAnimationFrame(() => {
        this.navTarget.scrollTop = parseInt(savedScrollTop, 10)
      })
    }
  }

  scrollToCurrentChapter() {
    // Find the current chapter link and scroll it into view if needed
    const currentLink = this.navTarget.querySelector('[class*="bg-indigo-50"]')
    if (currentLink) {
      // Only scroll if the current chapter is not visible
      const navRect = this.navTarget.getBoundingClientRect()
      const linkRect = currentLink.getBoundingClientRect()
      
      if (linkRect.top < navRect.top || linkRect.bottom > navRect.bottom) {
        currentLink.scrollIntoView({ 
          behavior: 'smooth', 
          block: 'center' 
        })
      }
    }
  }

  disconnect() {
    // Clean up when controller is removed
    this.linkTargets.forEach(link => {
      link.removeEventListener('click', this.saveScrollPosition.bind(this))
    })
  }
}