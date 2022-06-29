import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = ['radioButtons', "otherButton"]
  connect() {
    console.log('connected')
  }

  otherclicked(event) {

    console.log('other clicked function')

    this.radioButtonsTargets.forEach(radioButton => {
      console.log(radioButton)
      radioButton.checked = false
    });

    event.target.classList.toggle('active')
  }

  radioclicked(event) {

    console.log('radio clicked function')
    this.otherButtonTarget.classList.remove('active')
  }
}
