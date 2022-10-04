import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="check-document"
export default class extends Controller {
  static targets = [ 'infoDiv', 'documentForm' ]

  static values = {
    document: Object,
  }

  connect() {
    this.documentFormTargets.forEach((documentLabel, i) => {
      this.documentValue.documents.forEach((document) => {
        if (document.document) {
          documentLabel.innerText = 'Modifier'
          documentLabel.classList.add('label-document-input-selected')
          this.infoDivTargets[i].insertAdjacentHTML('beforeend', '<em>Document déjà fourni</em>')
        }
      })
    })
  }
}
