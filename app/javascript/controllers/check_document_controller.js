import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="check-document"
export default class extends Controller {
  static targets = [ 'infoDiv', 'documentForm' ]

  static values = {
    document: Object,
  }

  connect() {
    this.documentFormTargets.forEach((document, i) => {
      this.documentValue.documents.forEach((orderDocument, j) => {
        if (orderDocument.document) {
          if (i == j) {
            document.innerText = 'Modifier'
            document.classList.add('label-document-input-selected')

            this.infoDivTargets[i].insertAdjacentHTML('beforeend', '<em>Document déjà fourni</em>')
          }
        }
      })
    })
  }
}
