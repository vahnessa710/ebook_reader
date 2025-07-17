// app/javascript/controllers/font_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = {
    fontSize: Number
  }

  connect() {
    console.log("Font controller connected!") // ← THIS SHOULD SHOW
    this.updateFontSize()
  }

  increase() {
    this.fontSizeValue += 1
    this.updateFontSize()
  }

  decrease() {
    this.fontSizeValue -= 1
    this.updateFontSize()
  }

  updateFontSize() {
    if (this.hasContentTarget) {
      this.contentTarget.style.fontSize = `${this.fontSizeValue}px`
    }
  }
}
