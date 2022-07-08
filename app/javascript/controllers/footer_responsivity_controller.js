import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="footer-responsivity"
export default class extends Controller {
  static targets = [ 'footerItems', 'bigLogo', 'shortLogo' ]

  connect() {
    this.toggle()
  }

  toggle() {
    if(window.innerWidth <= 900) {
      this.footerItemsTarget.classList.add('display-none');
      this.bigLogoTarget.classList.add('display-none');
      this.shortLogoTarget.classList.remove('display-none');
    } else {
      this.footerItemsTarget.classList.remove('display-none');
      this.bigLogoTarget.classList.remove('display-none');
      this.shortLogoTarget.classList.add('display-none');
    }
  }
}
