import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="check-for-added-contracts"
export default class extends Controller {
  static values = {
    addedIds: Array,
  }

  connect(){
    this.checkForAddedIds()
  }

  checkForAddedIds(){
    this.addedIdsValue.forEach(id => {
      const accountCard = document.getElementById(`account_${id}`)
      this.update(accountCard)
    });
  }

  update(element) {
    element.parentElement.classList.remove('to-add')
    element.parentElement.disabled = true
    element.childNodes[1].innerText = "ajouté ✓"
  }
}
