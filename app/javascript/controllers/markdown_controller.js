import { Controller } from "@hotwired/stimulus"
import { marked } from "marked"

export default class extends Controller {
  static targets = ["content", "toc"]

  connect() {
    this.renderMarkdown()
  }

  async renderMarkdown() {
    const markdownContent = this.contentTarget.textContent.trim()

    // Configure marked without syntax highlighting (for better performance)
    marked.setOptions({
      breaks: true,
      gfm: true
    })

    // Render markdown to HTML
    const html = await marked.parse(markdownContent)
    this.contentTarget.innerHTML = html

    // Add copy buttons to code blocks
    this.addCopyButtons()

    // Generate table of contents if we have a TOC target
    if (this.hasTocTarget) {
      this.generateTableOfContents()
    }

    // Add fade-in animation
    this.contentTarget.classList.add('fade-in')
  }

  addCopyButtons() {
    const codeBlocks = this.contentTarget.querySelectorAll('pre code')

    codeBlocks.forEach((codeBlock) => {
      const pre = codeBlock.parentElement
      pre.classList.add('relative', 'group')

      const copyButton = document.createElement('button')
      copyButton.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
        </svg>
      `
      copyButton.className = 'absolute top-2 right-2 p-2 bg-gray-700 hover:bg-gray-600 text-white rounded opacity-0 group-hover:opacity-100 transition-opacity duration-200 copy-button'
      copyButton.setAttribute('data-action', 'click->markdown#copy')
      copyButton.setAttribute('title', 'Copy code')

      pre.appendChild(copyButton)

      // Store the code content as a data attribute
      copyButton.dataset.code = codeBlock.textContent
    })
  }

  copy(event) {
    const button = event.currentTarget
    const code = button.dataset.code

    navigator.clipboard.writeText(code).then(() => {
      // Change button to show success
      button.innerHTML = `
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
        </svg>
      `
      button.classList.add('bg-green-600', 'hover:bg-green-500')
      button.classList.remove('bg-gray-700', 'hover:bg-gray-600')

      // Reset after 2 seconds
      setTimeout(() => {
        button.innerHTML = `
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
          </svg>
        `
        button.classList.remove('bg-green-600', 'hover:bg-green-500')
        button.classList.add('bg-gray-700', 'hover:bg-gray-600')
      }, 2000)
    }).catch(err => {
      console.error('Failed to copy:', err)
    })
  }

  generateTableOfContents() {
    const headings = this.contentTarget.querySelectorAll('h1, h2, h3')

    if (headings.length < 3) {
      // Don't show TOC if there are less than 3 headings
      this.tocTarget.style.display = 'none'
      return
    }

    const tocList = document.createElement('ul')
    tocList.className = 'space-y-2'

    headings.forEach((heading, index) => {
      // Add ID to heading for linking
      const id = `heading-${index}`
      heading.id = id

      // Create TOC item
      const li = document.createElement('li')
      const link = document.createElement('a')
      link.href = `#${id}`
      link.textContent = heading.textContent
      link.className = 'text-sm hover:text-indigo-600 transition-colors duration-200'

      // Indent based on heading level
      if (heading.tagName === 'H2') {
        li.className = 'ml-0'
      } else if (heading.tagName === 'H3') {
        li.className = 'ml-4 text-gray-600'
        link.className = 'text-sm hover:text-indigo-600 transition-colors duration-200 text-gray-600'
      } else {
        li.className = 'font-semibold'
      }

      li.appendChild(link)
      tocList.appendChild(li)
    })

    this.tocTarget.innerHTML = ''
    this.tocTarget.appendChild(tocList)
  }
}
