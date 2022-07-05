import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-file"
export default class extends Controller {
  static targets = ['input', 'label', 'fileNameDiv']

  added(){
    this.fileNameDivTarget.innerText = this.inputTarget.files[0].name
    this.labelTarget.classList.add('label-document-input-selected')
    this.labelTarget.innerText = 'Modifier'
  }
}
