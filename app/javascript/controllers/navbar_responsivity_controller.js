import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar-responsivity"
export default class extends Controller {
  static targets = [ 'navitems', 'hamburger' ]
  connect() {
    this.toggle()
  }

  toggle() {
    if(window.innerWidth <= 900) {
      this.navitemsTarget.classList.add('display-none');
      this.hamburgerTarget.classList.remove('display-none');
    } else {
      this.navitemsTarget.classList.remove('display-none');
      this.hamburgerTarget.classList.add('display-none');
    }
  }
}
