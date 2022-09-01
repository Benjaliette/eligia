import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="subcategory-dropdown"
export default class extends Controller {
  static targets = [ 'button', 'accounts' ]

  toggle() {
    this.accountsTarget.classList.toggle('active')
    this.buttonTarget.classList.toggle('toggle-btn-up')
  }
}
