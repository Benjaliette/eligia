import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard-scroll"
export default class extends Controller {
  static targets = [ 'notificationCard' ]

  connect() {
    console.log(this.notificationCardTarget)
    this.stickUnstick()
  }

  stickUnstick(){
    console.log(window.scrollY)
    if(window.scrollY > 164){
      this.notificationCardTarget.classList.add('position-sticky')
      console.log(this.notificationCardTarget.classList)
    }
    else{
      this.notificationCardTarget.classList.remove('position-sticky')
      console.log(this.notificationCardTarget.classList)

    }
  }
}
