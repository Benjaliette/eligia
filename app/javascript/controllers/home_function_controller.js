import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-function"
export default class extends Controller {
  static targets = [ 'navItem', 'infoDiv' ]


  infoAppear(event) {
    this.navItemTargets.forEach((navItem) => {
      navItem.classList.remove('current-item')
    })

    event.target.classList.add('current-item')

    this.infoDivTargets.forEach((div) => {
      if(event.target.id === div.id) {
        div.classList.remove('disapear')
      } else {
        div.classList.add('disapear')
      }
    })
  }
}
