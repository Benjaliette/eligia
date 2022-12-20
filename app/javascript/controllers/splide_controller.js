import { Controller } from "@hotwired/stimulus"
import Splide from '@splidejs/splide'

// Connects to data-controller="splide"
export default class extends Controller {
  connect() {
    new Splide( '.splide', {
      type   : 'loop',
      speed: 800,
      padding: '15%',
      fixedWidth : '45%',
      gap : '1em',
      breakpoints: {
        900: {
          type   : 'slide',
          fixedWidth : '80%',
          padding: {left:0, right: '10%'},
        },
        600: {
          fixedWidth : '80%',
          padding: {left:0, right: '5%'},
        },
      }
    }
     ).mount();
  }
}
