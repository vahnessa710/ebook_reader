// app/javascript/controllers/chapter_link_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    bookId: Number,
    chapterId: Number
  }

  updateProgress(event) {
    // Only update progress if this isn't the current chapter
    if (!this.element.classList.contains('bg-indigo-50')) {
      fetch(`/books/${this.bookIdValue}/chapters/${this.chapterIdValue}/update_progress`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
        },
        credentials: 'same-origin'
      }).catch(error => console.error('Error:', error))
    }
  }
}