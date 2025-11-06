import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "selected", "input", "option", "arrow"]

  connect() {
    // Close dropdown when clicking outside
    this.closeOnClickOutside = this.closeOnClickOutside.bind(this)
    document.addEventListener('click', this.closeOnClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.closeOnClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    const isHidden = this.menuTarget.classList.contains('hidden')

    this.menuTarget.classList.toggle('hidden')

    // Rotate arrow
    const arrow = this.selectedTarget.querySelector('svg')
    if (arrow) {
      if (isHidden) {
        arrow.style.transform = 'rotate(180deg)'
      } else {
        arrow.style.transform = 'rotate(0deg)'
      }
    }

    // Add animation
    if (isHidden) {
      this.menuTarget.classList.add('scale-in')
    }
  }

  select(event) {
    const option = event.currentTarget
    const investorId = option.dataset.investorId
    const investorName = option.dataset.investorName
    const investorPersona = option.dataset.investorPersona
    const investorInitials = option.dataset.investorInitials

    // Update hidden input
    this.inputTarget.value = investorId

    // Update selected display
    this.selectedTarget.innerHTML = `
      <div class="flex items-center space-x-3">
        <div class="w-10 h-10 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
          ${investorInitials}
        </div>
        <div class="flex-1 text-left">
          <div class="font-semibold text-gray-900">${investorName}</div>
          <div class="text-xs text-gray-600">${investorPersona}</div>
        </div>
        <svg class="w-5 h-5 text-gray-400 transition-transform duration-200" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
        </svg>
      </div>
    `

    // Mark as selected
    this.optionTargets.forEach(opt => {
      opt.classList.remove('bg-indigo-50', 'border-indigo-600')
      opt.classList.add('border-gray-200')
      const checkmark = opt.querySelector('.checkmark')
      if (checkmark) checkmark.classList.add('hidden')
    })

    option.classList.add('bg-indigo-50', 'border-indigo-600')
    option.classList.remove('border-gray-200')
    const checkmark = option.querySelector('.checkmark')
    if (checkmark) checkmark.classList.remove('hidden')

    // Close menu
    this.menuTarget.classList.add('hidden')

    // Reset arrow rotation
    const arrow = this.selectedTarget.querySelector('svg')
    if (arrow) {
      arrow.style.transform = 'rotate(0deg)'
    }
  }

  closeOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add('hidden')

      // Reset arrow rotation
      const arrow = this.selectedTarget.querySelector('svg')
      if (arrow) {
        arrow.style.transform = 'rotate(0deg)'
      }
    }
  }
}
