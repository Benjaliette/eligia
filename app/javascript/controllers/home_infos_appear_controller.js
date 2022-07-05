import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-infos-appear"
export default class extends Controller {
  static targets = [ "infoItems" ]

  transition() {
    this.infoItemsTargets.forEach((infoItem, i) => {
      const divTop = infoItem.getBoundingClientRect().top

      if (divTop < 400) {
        infoItem.classList.add('active')
      }

      if (i === 0 && window.scrollY > 2000) {
        infoItem.classList.remove('active')
      } else if (i === 1 && window.scrollY > 3000) {
        infoItem.classList.remove('active')
      } else if (i === 2 && window.scrollY > 3800) {
        infoItem.classList.remove('active')
      }

    });

  }
}
