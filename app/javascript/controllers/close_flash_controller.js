import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="close-flash"
export default class extends Controller {
  static targets = [ 'alert' ]

  connect() {
    setTimeout(() => {
      this.alertTarget.remove();
    }, 5000)
  }

  closePartial() {
    this.alertTarget.remove()
  }
}
