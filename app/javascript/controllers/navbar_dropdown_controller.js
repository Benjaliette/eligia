import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-dropdown"
export default class extends Controller {
  static targets = [ 'hamburgerIcon', 'avatar', 'dropdowndiv', 'toggleDropdowndiv', 'notifications', 'notificationsIcon']

  dropdown(){
    this.dropdowndivTarget.classList.toggle('navbar-dropdown-visible')
  }

  toggleDropdown(event) {
    this.toggleDropdowndivTarget.classList.toggle('display-none')
    this.hamburgerIconTarget.classList.toggle('fa-bars')
    this.hamburgerIconTarget.classList.toggle('fa-xmark')
    this.notificationsIconTarget.classList.toggle('display-none')

  }

  closeDropdown(event) {
    if (event.srcElement != this.avatarTarget) {
      this.dropdowndivTarget.classList.remove('navbar-dropdown-visible')
    }
  }

  toggleNotifications(event) {
    this.notificationsTarget.classList.toggle('display-none')
    this.hamburgerIconTarget.classList.toggle('display-none')
    this.notificationsIconTarget.classList.toggle('fa-xmark')
    this.notificationsIconTarget.classList.toggle('fa-solid')
    this.notificationsIconTarget.classList.toggle('fa-xl')
    this.notificationsIconTarget.classList.toggle('fa-regular')
    this.notificationsIconTarget.classList.toggle('fa-message')
  }
}
