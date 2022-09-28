import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-navbar"
export default class extends Controller {
  static targets = [ 'navbar', 'button' ]

  connect() {
    this.changeBackground()
  }

  changeBackground() {
    if(window.scrollY > 80) {
      this.navbarTarget.classList.add('white-bg')
    } else {
      this.navbarTarget.classList.remove('white-bg')
    }
    if(this.hasButtonTarget){
      if(window.scrollY > 500) {
        this.buttonTarget.classList.remove('display-none')
        } else {
        this.buttonTarget.classList.add('display-none')
      }
    }
  }
}
