// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 5000) // 3 seconds
  }

  dismiss() {
    this.element.classList.add('opacity-0', 'transition-opacity', 'duration-300')
    setTimeout(() => {
      this.element.remove()
    }, 300) // Wait for fade-out to complete
  }
}