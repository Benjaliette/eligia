import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-contracts"
export default class extends Controller {
  static targets = [ 'accountList' ]

  displayList() {
    this.accountListTarget.classList.toggle('d-block')
  }
}
