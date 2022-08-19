import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="other-account"
export default class extends Controller {
  static targets = [ "checkBoxes", "otherButton", "subcategoryDiv", "form", "accountInput" ]

  static values = {
    order: Object,
    subcategory: Number,
    accountNumber: Number,
  }

  otherCheckNumber = 0
  currentButton = 0;

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


    if (this.otherButtonTargets[event.srcElement.id].innerText == 'Autre') {
      this.otherButtonTargets[event.srcElement.id].classList.toggle('active');
    } else {
      this.otherButtonTargets[event.srcElement.id].classList.add('active');
    }

    this.accountInputTarget.value = ''
    this.currentButton = event.srcElement.id
  }


  buttonText(event) {
    if (event.key.length === 1 || event.keyCode === 8) {
      if (event.srcElement.value == '') {
        this.otherButtonTargets[this.currentButton].textContent = 'Autre';
      } else {
        this.otherButtonTargets[this.currentButton].textContent = event.srcElement.value;
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

    if (this.otherButtonTargets.some(button => button.innerText == 'Autre')) {
      return
    } else {
      if (this.otherButtonTarget.textContent != 'Autre') {
        this.addOtherButton()
      } else {
        this.otherButtonTarget.classList.remove('active');
      }
    }
  }

  removeAccount() {
    this.subcategoryDivTarget.classList.add('display-none');
    this.otherButtonTarget.textContent = 'Autre';
    this.otherButtonTarget.classList.remove('active');
  }

  addOtherButton() {
    this.otherCheckNumber++

    const otherButton = `
    <label class="string optional account-other-button active"
           id=${this.otherCheckNumber}
           data-action="click->other-account#otherclicked"
           data-other-account-target="otherButton"
           for="order_order_accounts_attributes_0_autre">
      Autre
    </label>
    `
    this.subcategoryDivTarget.insertAdjacentHTML('beforebegin', otherButton)

    this.otherButtonTargets[this.otherCheckNumber].classList.remove('active');
  }
}
