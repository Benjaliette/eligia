import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = ['radioButtons', "otherButton", "subcategoryDiv"]
  connect() {
    console.log('connected')
  }

  otherclicked(event) {
    console.log('other clicked function')

    this.radioButtonsTargets.forEach(radioButton => {
      console.log(radioButton)
      radioButton.checked = false
    });

    this.subcategoryDivTarget.classList.toggle('display-none');

    event.target.classList.toggle('active')
  }

  radioclicked(event) {

    console.log('radio clicked function')
    this.otherButtonTarget.classList.remove('active')
  }
}
