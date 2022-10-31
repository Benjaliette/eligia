import { Controller } from "@hotwired/stimulus"
import { autofill } from '@mapbox/search-js-web';

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static targets = [ "address", "input" ]

  static values = {
    apiKey: String,
    address: String
  }

  connect() {
    const ACCESS_TOKEN = this.apiKeyValue;

    const elements = document.querySelectorAll('mapbox-address-autofill');
    for (const autofill of elements) {
      autofill.accessToken = ACCESS_TOKEN;
    }
  }
}
