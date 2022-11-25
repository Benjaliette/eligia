import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-checks"
export default class extends Controller {
  static values = {
    document: String,
    format: String,
  }

  updateText(event) {
    const regexes = {
      'telephone_mobile': /^(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8})$/,
      'telephone_fixe': /^(\(\+33\)|0|\+33|0033)[1-9]([0-9]{8})$/,
      'iban': /^[A-Z]{2}(?:[ ]?[0-9]){18,25}$/i,
      'email': /^(\w+\.?|-?\w+?)+@\w+\.?-?\w+?(\.\w{2,3})+$/i,
    }
    const regexp = regexes[this.formatValue]
    const inputValue = event.target.value.replaceAll(' ', '')
    if (regexp === undefined) {
      this.checkElement()
    } else if(regexp.test(inputValue)) {
      this.checkElement()
    } else {
      this.removeCheckedElement()
    }
  }

  updateFile() {
    this.checkElement()
  }

  checkElement() {
    const element = document.querySelectorAll(`.order_doc_${this.documentValue}`)
    element.forEach(el => el.classList.add('added'))
  }

  removeCheckedElement() {
    const element = document.querySelectorAll(`.order_doc_${this.documentValue}`)
    element.forEach(el => el.classList.remove('added'))
  }
}
