import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="transparent-navbar"
export default class extends Controller {
  connect() {
    const navbar = document.querySelector('.navbar');
    navbar.style.background = 'transparent';
    navbar.style.boxShadow = "0px 0px 0px blue";

    const body = document.querySelector('body');
    body.classList.add('body-home');
  }
}
