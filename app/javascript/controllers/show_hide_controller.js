import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-hide"
export default class extends Controller {
  static targets = ['element']
  connect(){
    console.log('connected')
  }
  toggle() {
    this.elementTarget.classList.toggle('display-none')
  }
}
