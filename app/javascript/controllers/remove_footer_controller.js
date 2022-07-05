import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-footer"
export default class extends Controller {
  connect() {
    const footer = document.querySelector('.footer');

    footer.remove();
  }
}
