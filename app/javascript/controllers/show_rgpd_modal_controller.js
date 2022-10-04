import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-rgpd-modal"
export default class extends Controller {
  static targets = ["modal"]

  show(){
    this.modalTarget.classList.toggle('display-none')
  }
}
