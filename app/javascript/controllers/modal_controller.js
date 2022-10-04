import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ 'modal' ]

  modalAppear() {
    this.modalTarget.classList.remove('display-none')
  }

  modalClose() {
    this.modalTarget.classList.add('display-none')
  }

  show(){
    this.modalTarget.classList.toggle('display-none')
  }
}
