import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

Chart.register(...registerables)

export default class extends Controller {
  static values = {
    data: Array,
    ticker: String
  }

  connect() {
    this.renderChart()
  }

  renderChart() {
    const ctx = this.element

    // Prepare data for Chart.js
    const labels = this.dataValue.map(d => d.date)
    const prices = this.dataValue.map(d => d.close)

    new Chart(ctx, {
      type: 'line',
      data: {
        labels: labels,
        datasets: [{
          label: `${this.tickerValue} Price`,
          data: prices,
          borderColor: 'rgb(99, 102, 241)',
          backgroundColor: 'rgba(99, 102, 241, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4,
          pointRadius: 0,
          pointHoverRadius: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: {
          intersect: false,
          mode: 'index'
        },
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            displayColors: false,
            callbacks: {
              title: (context) => {
                return new Date(context[0].label).toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'short',
                  day: 'numeric'
                })
              },
              label: (context) => {
                return `$${context.parsed.y.toFixed(2)}`
              }
            }
          }
        },
        scales: {
          x: {
            display: true,
            grid: {
              display: false
            },
            ticks: {
              maxTicksLimit: 6,
              callback: function(value, index) {
                const date = new Date(this.getLabelForValue(value))
                return date.toLocaleDateString('en-US', { month: 'short', year: '2-digit' })
              }
            }
          },
          y: {
            display: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.05)'
            },
            ticks: {
              callback: function(value) {
                return '$' + value.toFixed(0)
              }
            }
          }
        }
      }
    })
  }
}
