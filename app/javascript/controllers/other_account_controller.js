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
            account.classList.add('active');
          }
        });
      });

      if (this.otherAccountValue != 0) {
        let i = 0

        this.orderValue.accounts.forEach((orderAccount) => {
          if ((orderAccount.account_id == null || orderAccount.account_valid == 'non_validated') && this.subcategoryValue == orderAccount.account_subcategory) {
            this.otherButtonTargets[i].classList.remove('display-none')
            this.otherButtonTargets[i].classList.add('active');
            if (this.otherButtonTargets[i].innerText == 'Autre' ) {
              this.otherButtonTargets[i].innerText = orderAccount.account_name.replaceAll('_', ' ');
            }
            this.otherButtonInputTargets[i].value = orderAccount.account_name.replaceAll('_', ' ')
            i++
          }
        })

        this.otherButtonTargets[i].classList.remove('display-none')
      }
    } catch(err) {
    }
  }

  otherclicked(event) {

    if (this.otherButtonTargets[event.srcElement.id].classList.contains('active')) {
      this.otherButtonTargets[event.srcElement.id].classList.remove('active');
      this.otherButtonTargets[event.srcElement.id].innerText = 'Autre'
      if (this.otherButtonTargets[event.srcElement.id].innerText == 'Autre') {
        this.subcategoryDivTarget.classList.add('display-none')
      }
      if (this.otherButtonTargets[Math.floor(event.srcElement.id) + 1].innerText == 'Autre') {
        this.otherButtonTargets[Math.floor(event.srcElement.id) + 1].classList.add('display-none')
      }
    } else {
      this.subcategoryDivTarget.classList.remove('display-none')
      this.otherButtonTargets[event.srcElement.id].classList.add('active');
    }

    this.accountInputTarget.value = ''

    this.currentButton = event.srcElement.id
    this.otherCheckNumber = Math.floor(this.currentButton) + 1
  }

  radioClicked(event) {
    event.srcElement.classList.toggle('active')
    if (!event.srcElement.classList.contains('active')) {
      event.srcElement.checked = false
    }
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
    const array = this.otherButtonTargets.filter(other => !other.classList.contains('display-none'))

    if (!array.some(item => item.innerText == 'Autre')) {
      this.otherButtonTargets[this.otherCheckNumber].classList.remove('display-none')
      this.otherButtonTargets[this.otherCheckNumber].classList.remove('active');
    }
  }
}
