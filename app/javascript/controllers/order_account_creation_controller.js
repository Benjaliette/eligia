import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order-account-creation"
export default class extends Controller {
  static targets = [ 'button', 'modal', 'card' ]

  static values = {
    account: String,
  }

  updateButton() {
    this.update(this.buttonTarget, this.cardTarget)
  }

  updateOtherButton() {
    this.update(this.buttonTarget, this.cardTarget)
    this.buttonTarget.value = "créé ✓"
  }

  updateOtherCards() {
    this.update(this.buttonTarget, this.cardTarget)
    const updatedCard = document.getElementById(this.accountValue)
    console.log(updatedCard)
    this.update(updatedCard.childNodes[1], updatedCard.parentElement)
  }

  update(button, card) {
    card.classList.remove('to-add')
    card.disabled = true
    button.innerText = "ajouté ✓"
  }

  modalAppear() {
    this.modalTarget.classList.remove('display-none')
  }

  modalDisappear() {
    this.modalTarget.classList.add('display-none')
  }
}
