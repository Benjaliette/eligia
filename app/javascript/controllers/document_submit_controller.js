import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="document-submit"
export default class extends Controller {
  static targets = ['submitBtn']

  submitAll(event){
    event.preventDefault
    this.submitBtnTargets.forEach(submitBtn => {
      submitBtn.submit()
    });
    // this.submitBtnTargets[0].submit()
  }
}
