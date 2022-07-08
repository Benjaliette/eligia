import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activate-current-order-step"
export default class extends Controller {
  static targets = [ "step" ]
  static values = { id: Number }

  connect() {
    this.stepTargets[this.idValue].classList.add('current-step')
    this.toggle()
  }

  toggle() {
    if(window.innerWidth <= 900) {
      const stepsArray = [0, 1, 2]
      stepsArray.splice(stepsArray.indexOf(this.idValue), 1)
      stepsArray.forEach(stepid => {
        this.stepTargets[stepid].classList.add('display-none')
      });
    }
    else {
      this.stepTargets.forEach(stepTarget => {
        stepTarget.classList.remove('display-none')
      });
    }
  }
}
