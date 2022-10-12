import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scroll-navbar"
export default class extends Controller {
  static targets = [ 'navbar', 'button' ]

  connect() {
    console.log('hello')
    this.changeBackground()
  }

  changeBackground() {

  }
}
