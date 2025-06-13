import { Controller } from "@hotwired/stimulus"

      export default class extends Controller {
        static targets = ["panel", "content", "menuIcon", "closeIcon"]

        connect() {
          console.log("hello word")
        }
        
        toggle() {
          this.panelTarget.classList.toggle('-translate-x-full')
          this.panelTarget.classList.toggle('md:translate-x-0')
          
          // Toggle icons
          document.getElementById('menu-icon').classList.toggle('hidden')
          document.getElementById('close-icon').classList.toggle('hidden')
          
          // Move toggle button position on desktop
          document.getElementById('sidebar-toggle').classList.toggle('md:left-4')
          document.getElementById('sidebar-toggle').classList.toggle('md:left-64')
          
          // Adjust content margin on desktop
          this.contentTarget.classList.toggle('md:ml-64')
        }
      }