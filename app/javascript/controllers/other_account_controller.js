import { Controller } from "@hotwired/stimulus"

let radioCheckNumber = 0;
let lastclicked;

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = ['radioButtons', "otherButton", "subcategoryDiv"]

  otherclicked(event) {
    this.radioButtonsTargets.forEach(radioButton => {
      radioButton.checked = false
    });

    this.subcategoryDivTarget.classList.toggle('display-none');
    this.otherButtonTarget.classList.toggle('active');

    lastclicked = event.target;
  }

  radioclicked(event) {
    radioCheckNumber ++

    this.subcategoryDivTarget.classList.add('display-none');
    this.otherButtonTarget.classList.remove('active');

    if (radioCheckNumber % 2 === 0 && lastclicked === event.target) {
      event.target.checked = false
    } else {
      event.target.checked = true
    }

    lastclicked = event.target;
  }

  buttonText(event) {
    if (event.key.length === 1) {
      this.otherButtonTarget.textContent = event.srcElement.value;
    }


  }
}
