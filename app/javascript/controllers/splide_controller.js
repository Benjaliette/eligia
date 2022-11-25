import { Controller } from "@hotwired/stimulus"
import Splide from '@splidejs/splide'

// Connects to data-controller="splide"
export default class extends Controller {
  connect() {
    new Splide( '.splide',{
      type   : 'loop',
      speed: 800,
      padding: '20%',
      fixedWidth : '60%',
      gap : '1em'
    } ).mount();
  }
}
