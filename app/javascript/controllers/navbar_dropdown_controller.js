import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-dropdown"
export default class extends Controller {
  static targets = [ 'hamburgerIcon', 'avatar', 'dropdowndiv', 'toggleDropdowndiv']

  dropdown(){
    this.dropdowndivTarget.classList.toggle('navbar-dropdown-visible')
  }

  toggleDropdown(event) {
    this.toggleDropdowndivTarget.classList.toggle('display-none')
    this.hamburgerIconTarget.classList.toggle('fa-bars')
    this.hamburgerIconTarget.classList.toggle('fa-xmark')
  }

  closeDropdown(event) {
    if (event.srcElement != this.avatarTarget) {
      this.dropdowndivTarget.classList.remove('navbar-dropdown-visible')
    }
  }
}
