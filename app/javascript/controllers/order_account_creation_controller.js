import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-account-creation"
export default class extends Controller {
  static targets = [ 'button' ]

  static values = {
    account: String,
  }

  updateButton(event) {
    this.buttonTarget.value = "ajouté ✓"
    this.update(this.buttonTarget)
    if (!event.target.parentElement.id){
      this.updateOtherCards()
    }
  }

  updateOtherButton() {
    this.buttonTarget.value = "créé ✓"
    this.update(this.buttonTarget)
  }

  updateOtherCards() {
    const updatedCard = document.getElementById(this.accountValue)
    this.update(updatedCard.childNodes[1][3])
  }

  update(button) {
    button.classList.remove('to-add')
    button.disabled = true
    button.value = "ajouté ✓"
  }
}
