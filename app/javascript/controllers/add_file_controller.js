import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-file"
export default class extends Controller {
  static targets = ['input', 'label', 'fileNameDiv']

  added(){
    const regex = /.*.(?:png|jpg|jpeg|pdf)/

    if (this.inputTarget.files[0].name.match(regex) === null) {
      this.fileNameDivTarget.innerText = 'ERREUR ! Le format doit être .png, .jpeg ou .jpg'
      this.labelTarget.classList.add('label-document-input-wrong-format')
      this.labelTarget.innerText = 'Modifier'

    }
    else {
      this.fileNameDivTarget.innerText = this.inputTarget.files[0].name
      this.labelTarget.classList.add('label-document-input-selected')
      this.labelTarget.classList.remove('label-document-input-wrong-format')
      this.labelTarget.innerText = 'Modifier'
    }
  }
}
