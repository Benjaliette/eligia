import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="other-account"

export default class extends Controller {
  static targets = [ "checkBoxes", "otherButton", "otherButtonInput", "subcategoryDiv", "form", "accountInput" ]

  static values = {
    order: Object,
    subcategory: Number,
    accountNumber: Number,
    subcategoryNumber: Number,
    otherAccount: Number,
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


            };
          };
        });
      });

    }
    catch(err) {
    }
    if (this.otherAccountValue != 0) {
      let i = 0

      this.orderValue.accounts.forEach((orderAccount) => {
        if (orderAccount.account_id > this.accountNumberValue) {
          this.otherButtonTargets[i].classList.remove('display-none')
          this.otherButtonTargets[i].classList.add('active');
          if (this.otherButtonTargets[i].innerText == 'Autre' ) {
            this.otherButtonTargets[i].innerText = orderAccount.account_name.replace('_', ' ');
          }

          i++
        }
      })

      this.otherButtonTargets[i].classList.remove('display-none')
    }
  }

  otherclicked(event) {
    this.subcategoryDivTarget.classList.toggle('display-none');


    if (this.otherButtonTargets[event.srcElement.id].innerText == 'Autre' && this.currentButton != event.srcElement.id) {
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
        this.otherButtonInputTargets[this.currentButton].value = "";
      } else {
        this.otherButtonTargets[this.currentButton].textContent = event.srcElement.value;
        this.otherButtonInputTargets[this.currentButton].value = event.srcElement.value;
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

      if (this.otherButtonTarget.textContent != 'Autre') {
        this.addOtherButton()
      } else {
        this.otherButtonTarget.classList.remove('active');
      }

  }

  removeAccount() {
    this.subcategoryDivTarget.classList.add('display-none');
    this.otherButtonTargets[this.currentButton] = 'Autre';
    this.otherButtonTargets[this.currentButton].classList.remove('active');
  }

  addOtherButton() {
    this.otherCheckNumber++

    this.otherButtonTargets[this.otherCheckNumber].classList.remove('display-none')

    this.otherButtonTargets[this.otherCheckNumber].classList.remove('active');
  }
}
