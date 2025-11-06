import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "form"]

  connect() {
    // Add fade-in animation to the form
    this.element.classList.add('opacity-0')
    setTimeout(() => {
      this.element.classList.remove('opacity-0')
      this.element.classList.add('animate-fade-in')
    }, 100)
  }

  submit(event) {
    if (!this.hasSubmitTarget) return

    // Disable submit button
    this.submitTarget.disabled = true
    this.submitTarget.classList.add('opacity-50', 'cursor-not-allowed')

    // Add loading spinner
    const originalText = this.submitTarget.innerHTML
    this.submitTarget.innerHTML = `
      <svg class="animate-spin h-5 w-5 mx-auto" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
    `

    // Store original text in case we need to restore it
    this.submitTarget.dataset.originalText = originalText
  }
}
