import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="account-search-autocomplete"
export default class extends Controller {
  static targets = [ 'form', 'input' ]

  submitForm() {
    this.formTarget.requestSubmit()
  }

  clearInput() {
    this.inputTarget.value = ""
    this.submitForm()
  }
}
