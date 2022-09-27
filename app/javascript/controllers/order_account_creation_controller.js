import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-account-creation"
export default class extends Controller {
  static targets = [ 'button' ]

  updateButton() {
    this.buttonTarget.value = "ajouté ✓"
    this.buttonTarget.classList.remove('to-add')
    this.buttonTarget.disabled = true
  }

  initialButton(event) {
    console.log(this.buttonTarget)
  }
}
