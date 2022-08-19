import { Controller } from "@hotwired/stimulus"

let radioCheckNumber = 0;
let lastclicked;

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = ['checkBoxes', "otherButton", "subcategoryDiv"]

  static values = {
    order: Object,
    subcategory: Number,
    accountNumber: Number,
  }

  connect() {
    try {
      this.checkBoxesTargets.forEach((account) => {
        this.orderValue.accounts.forEach((orderAccount) => {
          if (account.value == orderAccount.account_id) {
            account.setAttribute('checked', true);
          } else if (orderAccount.account_id >= Math.floor(this.accountNumberValue) + 1) {
            if (this.subcategoryValue == orderAccount.account_subcategory) {
              this.otherButtonTarget.classList.add('active');
              this.otherButtonTarget.innerText = orderAccount.account_name.replace('_', ' ');
            };
          };
        });
      });
    }
    catch(err) {
    }

  }

  otherclicked(event) {
    this.subcategoryDivTarget.classList.toggle('display-none');
    this.otherButtonTarget.classList.add('active');
  }


  buttonText(event) {
    if (event.key.length === 1 || event.keyCode === 8) {
      if (event.srcElement.value == '') {
        this.otherButtonTarget.textContent = 'Autre';
      } else {
        this.otherButtonTarget.textContent = event.srcElement.value;
      };

    };
  }

  preventSubmit(event) {
    if(event.keyCode === 13) {
      event.preventDefault()
    };
  }

  accountTyped() {
    this.subcategoryDivTarget.classList.add('display-none');
  }

  removeAccount() {
    this.subcategoryDivTarget.classList.add('display-none');
    this.otherButtonTarget.textContent = 'Autre';
    this.otherButtonTarget.classList.remove('active');
  }
}
