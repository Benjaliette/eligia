import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-password"
export default class extends Controller {
  static targets = [ 'field', 'eye' ]

  show(){
    if (this.fieldTarget.type === 'password') {
      this.fieldTarget.type = 'text'
      this.eyeTarget.childNodes[1].classList.remove('fa-eye')
      this.eyeTarget.childNodes[1].classList.add('fa-eye-slash')
    }
    else {
      this.fieldTarget.type = 'password'
      this.eyeTarget.childNodes[1].classList.add('fa-eye')
      this.eyeTarget.childNodes[1].classList.remove('fa-eye-slash')
    }
  }
}
