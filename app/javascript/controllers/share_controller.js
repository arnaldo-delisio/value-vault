import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "icon"]

  copyLink(event) {
    event.preventDefault()

    const url = window.location.href

    navigator.clipboard.writeText(url).then(() => {
      // Show success state
      this.iconTarget.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
      `

      // Update button text
      const originalText = this.buttonTarget.innerHTML
      this.buttonTarget.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
        Copied!
      `
      this.buttonTarget.classList.add('bg-green-600', 'hover:bg-green-700')
      this.buttonTarget.classList.remove('bg-gray-600', 'hover:bg-gray-700')

      // Reset after 2 seconds
      setTimeout(() => {
        this.buttonTarget.innerHTML = originalText
        this.buttonTarget.classList.remove('bg-green-600', 'hover:bg-green-700')
        this.buttonTarget.classList.add('bg-gray-600', 'hover:bg-gray-700')
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy link:', err)
      alert('Failed to copy link to clipboard')
    })
  }
}
