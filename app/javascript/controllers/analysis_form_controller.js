import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submit", "submitText", "spinner", "ticker", "tickerError", "question", "questionError"]

  connect() {
    this.isSubmitting = false
  }

  validateTicker() {
    const ticker = this.tickerTarget.value.trim().toUpperCase()
    this.tickerTarget.value = ticker // Auto-uppercase

    // Ticker should be 1-5 letters only
    const tickerRegex = /^[A-Z]{1,5}$/

    if (!ticker) {
      this.showError(this.tickerErrorTarget, "Ticker is required")
      return false
    } else if (!tickerRegex.test(ticker)) {
      this.showError(this.tickerErrorTarget, "Ticker must be 1-5 letters (e.g., AAPL, MSFT)")
      return false
    } else {
      this.hideError(this.tickerErrorTarget)
      return true
    }
  }

  validateQuestion() {
    const question = this.questionTarget.value.trim()

    if (!question) {
      this.showError(this.questionErrorTarget, "Please ask a question")
      return false
    } else if (question.length < 10) {
      this.showError(this.questionErrorTarget, "Please provide a more detailed question (at least 10 characters)")
      return false
    } else {
      this.hideError(this.questionErrorTarget)
      return true
    }
  }

  showError(target, message) {
    target.textContent = message
    target.classList.remove("hidden")
  }

  hideError(target) {
    target.classList.add("hidden")
  }

  submit(event) {
    // Prevent double submission
    if (this.isSubmitting) {
      event.preventDefault()
      return
    }

    // Validate form
    const tickerValid = this.validateTicker()
    const questionValid = this.validateQuestion()

    if (!tickerValid || !questionValid) {
      event.preventDefault()
      return
    }

    // Mark as submitting
    this.isSubmitting = true

    // Disable the submit button
    this.submitTarget.disabled = true

    // Hide the original text
    this.submitTextTarget.classList.add("hidden")

    // Show the loading spinner
    this.spinnerTarget.classList.remove("hidden")
  }
}
