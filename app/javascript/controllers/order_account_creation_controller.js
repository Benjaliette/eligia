import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-account-creation"
export default class extends Controller {
  static targets = [ 'button' ]

  static values = {
    account: String,
  }

  updateButton() {
    this.update(this.buttonTarget)
    this.updateOtherCards()
  }

  updateOtherCards() {
    const updatedCard = document.getElementById(this.accountValue)
    this.update(updatedCard.childNodes[1][3])
  }

  update(button) {
    button.value = "ajouté ✓"
    button.classList.remove('to-add')
    button.disabled = true
  }
}
