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
      this.update(accountCard.childNodes[1][3])
    });
  }

  update(element) {
    element.classList.remove('to-add')
    element.disabled = true
    element.value = "ajouté ✓"
  }
}
