import { Controller } from "@hotwired/stimulus"
import Splide from '@splidejs/splide'

// Connects to data-controller="splide"
export default class extends Controller {
  connect() {
    new Splide( '.splide',{
      type   : 'loop',
      speed: 8000,
    } ).mount();
  }
}
