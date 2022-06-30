import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-dropdown"
export default class extends Controller {
  static targets = ['dropdowndiv']

  dropdown(){
    console.log('clicked')
    this.dropdowndivTarget.classList.toggle('navbar-dropdown-visible')
  }
}
