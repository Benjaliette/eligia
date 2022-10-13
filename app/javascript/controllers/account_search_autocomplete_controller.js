import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="account-search-autocomplete"

export default class extends Controller {
  static targets = [ 'form', 'input', 'searchBar' ]

  submitForm() {
    this.formTarget.requestSubmit()
  }

  clearInput() {
    this.inputTarget.value = ""
    this.submitForm()
  }


  clickOutside(event){
    if(this.searchBarTarget === event.target || this.searchBarTarget.contains(event.target)) return;
    const inputValue = this.inputTarget.value
    this.clearInput()
    this.inputTarget.value = inputValue
  }
}
