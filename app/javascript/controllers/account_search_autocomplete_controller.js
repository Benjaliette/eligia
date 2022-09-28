import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="account-search-autocomplete"
export default class extends Controller {
  static targets = [ 'form', 'input' ]

  submitForm() {
    this.formTarget.submit().preventDefault();

  }
}
