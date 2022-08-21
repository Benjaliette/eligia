import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="show-password"
export default class extends Controller {
  static targets = ['field']

  show(){
    if (this.fieldTarget.type === 'password') {
      this.fieldTarget.type = 'text'
    }
    else {
      this.fieldTarget.type = 'password'
    }
  }
}
