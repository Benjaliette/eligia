import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="other-account"
export default class extends Controller {
  connect() {
    console.log('connected')
  }

  clicked(event) {
    console.log('benjadev')
    console.log(event.target)
    event.target.classList.toggle('active')
  }
}
