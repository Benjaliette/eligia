import { Controller, fetch } from "@hotwired/stimulus"

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
    if(this.hasNotificationIconTarget){
      this.notificationsIconTarget.classList.toggle('display-none')
    }
  }

  closeDropdown(event) {
    if (event.srcElement != this.avatarTarget) {
      this.dropdowndivTarget.classList.remove('navbar-dropdown-visible')
    }
  }

  toggleNotifications(event) {
    this.notificationsTarget.classList.toggle('display-none')
    if(this.hasNotificationIconTarget){
      this.notificationsIconTarget.classList.toggle('fa-comment')
      this.notificationsIconTarget.classList.toggle('fa-comment-slash')
    }
    if(event.target.childNodes.length > 1) {
      this.readNotifications(event)
    }
  }

  closeNotifications(event) {
    if (event.srcElement != this.notificationsIconTarget && !event.path.includes(this.notificationsTarget)) {
      this.notificationsTarget.classList.add('display-none')
    }
  }

  readNotifications(event) {
    event.target.parentElement.requestSubmit()
  }
}
