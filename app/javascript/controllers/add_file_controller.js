import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-file"
export default class extends Controller {
  static targets = ['input', 'label', 'fileNameDiv', 'submitBtn']
  connect(){

  }
  added(){
    const regex = /.*.(?:png|jpg|jpeg|pdf|JPG|JPEG|PNG|PDF)/
    if (this.inputTarget.files[0].size > 1048576 * 10) {
      alert("Fichier trop lourd. Taille maximum 10Mb")
      this.inputTarget.value = ''

    } else if (this.inputTarget.files[0].name.match(regex) === null) {
      this.fileNameDivTarget.innerText = 'ERREUR ! Le format doit être .png, .jpeg .jpg ou .pdf'
      this.labelTarget.classList.add('label-document-input-wrong-format')
      this.labelTarget.innerText = 'Modifier'

    } else {
      this.fileNameDivTarget.innerText = ''
      Array.from(this.inputTarget.files).forEach(file => {
        this.fileNameDivTarget.insertAdjacentHTML('beforeend', `<div>${file.name}</div>`)
      });
      this.labelTarget.classList.add('label-document-input-selected')
      this.labelTarget.classList.remove('label-document-input-wrong-format')
      this.labelTarget.innerText = 'Modifier'
      if(this.hasSubmitBtnTarget){
        this.submitBtnTarget.classList.remove('display-none')
      }
    }
  }
}
