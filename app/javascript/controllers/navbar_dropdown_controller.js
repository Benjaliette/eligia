import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-dropdown"
export default class extends Controller {
  static targets = [ 'hamburgerIcon', 'dropdowndiv', 'toggleDropdowndiv']

  connect() {

  }

  dropdown(){
    console.log('clicked')
    this.dropdowndivTarget.classList.toggle('navbar-dropdown-visible')
  }

  toggleDropdown(event) {
    this.toggleDropdowndivTarget.classList.toggle('display-none')
    this.hamburgerIconTarget.classList.toggle('fa-bars')
    this.hamburgerIconTarget.classList.toggle('fa-xmark')
  }
}
