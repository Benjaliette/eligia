import { Controller } from "@hotwired/stimulus"

let radioCheckNumber = 0;
let lastclicked;

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = ['radioButtons', "otherButton", "subcategoryDiv"]

  static values = {
    order: Object,
    subcategory: Number,
    accountNumber: Number,
  }

  connect() {
    this.radioButtonsTargets.forEach((account) => {
      this.orderValue.accounts.forEach((orderAccount) => {
        if (account.value == orderAccount.account_id) {
          account.setAttribute('checked', true)
        } else if (orderAccount.account_id >= Math.floor(this.accountNumberValue) + 1) {
          if (this.subcategoryValue == orderAccount.account_subcategory) {
            this.otherButtonTarget.classList.add('active')
            this.otherButtonTarget.innerText = orderAccount.account_name.replace('_', ' ')
          }
        }
      })
    })
  }

  otherclicked(event) {
    this.radioButtonsTargets.forEach(radioButton => {
      radioButton.checked = false
    });

    this.subcategoryDivTarget.classList.toggle('display-none');
    console.log(this.otherButtonTarget.innerText)
    if (this.otherButtonTarget.innerText == 'Autre' || !this.otherButtonTarget.classList.contains('active')) {
      this.otherButtonTarget.classList.toggle('active');
    }

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

  preventSubmit(event) {
    if(event.keyCode === 13) {
      event.preventDefault()
    }
  }
}
