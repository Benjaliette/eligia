import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="loading-spinner"
export default class extends Controller {
  static targets = ['spinner', 'btn']
  load() {
    this.spinnerTarget.classList.remove('display-none')
    this.btnTarget.classList.add('display-none')
  }
}