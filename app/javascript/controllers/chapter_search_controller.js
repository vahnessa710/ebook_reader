import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { contentId: String }
  
  connect() {
    this.debounceTimeout = null
    // Fallback to find content by ID if target not found
    this.contentElement = this.hasContentTarget ? 
      this.contentTarget : 
      document.getElementById(this.contentIdValue || 'content')
  }

  search() {
    clearTimeout(this.debounceTimeout)
    
    const term = this.inputTarget.value.trim()
    
    if (term.length === 0) {
      this.clearResults()
      return
    }

    this.debounceTimeout = setTimeout(() => {
      this.performSearch(term)
    }, 300)
  }

  async performSearch(term) {
    const url = `${window.location.pathname}?q[cont]=${encodeURIComponent(term)}`
    
    try {
      const response = await fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html'
        }
      })
      
      if (response.ok) {
        const html = await response.text()
        this.resultsTarget.innerHTML = html
        this.resultsTarget.classList.remove('hidden')
      }
    } catch (error) {
      console.error("Search failed:", error)
    }
  }

  highlightAndScroll(event) {
    if (!this.contentElement) {
      console.error("Content element not found")
      return
    }

    const text = event.target.dataset.text
    const term = this.inputTarget.value
    
    // Remove existing highlights
    this.removeHighlights()
    
    // Highlight all matches
    if (term && term.length > 0) {
      this.highlightMatches(term)
    }
    
    // Scroll to the specific match
    if (text) {
      this.scrollToMatch(text)
    }
  }

  // Helper methods
  clearResults() {
    this.resultsTarget.innerHTML = ''
    this.resultsTarget.classList.add('hidden')
    this.removeHighlights()
  }

  removeHighlights() {
    if (this.contentElement) {
      this.contentElement.querySelectorAll('.search-highlight').forEach(el => {
        el.outerHTML = el.innerHTML
      })
    }
  }

  highlightMatches(term) {
    if (!this.contentElement) return
    
    const regex = new RegExp(this.escapeRegExp(term), 'gi')
    this.contentElement.innerHTML = 
      this.contentElement.innerHTML.replace(regex, match => 
        `<span class="search-highlight bg-yellow-200 dark:bg-yellow-800">${match}</span>`
      )
  }

  scrollToMatch(text) {
    if (!this.contentElement) return
    
    const elements = Array.from(this.contentElement.querySelectorAll('*'))
      .filter(el => el.textContent.includes(text))
    
    if (elements.length > 0) {
      elements[0].scrollIntoView({ 
        behavior: 'smooth', 
        block: 'center' 
      })
    }
  }

  escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
  }
}