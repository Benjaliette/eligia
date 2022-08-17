import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-file"
export default class extends Controller {
  static targets = ['input', 'label', 'fileNameDiv']

  added(){
    const regex = /.*.(?:png|jpg)/

    if (this.inputTarget.files[0].name.match(regex) === null) {
      this.fileNameDivTarget.innerText = 'Le format doit être .png ou .jpg'
      this.labelTarget.classList.add('label-document-input-wrong-format')
      this.labelTarget.innerText = 'ERREUR'

    }
    else {
      this.fileNameDivTarget.innerText = this.inputTarget.files[0].name
      this.labelTarget.classList.add('label-document-input-selected')
      this.labelTarget.innerText = 'Modifier'
    }
  }
}
