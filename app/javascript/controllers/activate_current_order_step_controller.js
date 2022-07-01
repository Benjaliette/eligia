import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activate-current-order-step"
export default class extends Controller {
  static targets = [ "step" ]
  static values = { id: Number }
  connect() {
    this.stepTargets[this.idValue].classList.add('current-step')
  }
}
