import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-dropdown"
export default class extends Controller {
  static targets = [ 'hamburgerIcon', 'dropdowndiv', 'toggleDropdowndiv']

  connect() {
  }

  dropdown(){
    window.onclick = function(event){
      const dropDown = document.querySelector('.navbar-dropdown')
      const dropDownbtn = document.querySelector('.avatar')
      if (event.target != dropDown && dropDown.classList.contains('navbar-dropdown-visible')){
        dropDown.classList.remove('navbar-dropdown-visible')
      }
      else if (event.target === dropDownbtn) {
        dropDown.classList.add('navbar-dropdown-visible')
      }
    }
  }

  toggleDropdown(event) {
    this.toggleDropdowndivTarget.classList.toggle('display-none')
    this.hamburgerIconTarget.classList.toggle('fa-bars')
    this.hamburgerIconTarget.classList.toggle('fa-xmark')
  }

}
