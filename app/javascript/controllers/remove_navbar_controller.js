import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remove-navbar"
export default class extends Controller {
  connect() {
    const navbar = document.querySelector('.navbar');

    navbar.remove();
  }
}
