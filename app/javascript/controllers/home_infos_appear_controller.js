import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-infos-appear"
export default class extends Controller {
  static targets = [ "infoItems" ]

  transition() {
  }
}
