import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static targets = [ "address", "input" ]

  static values = {
    apiKey: String,
    address: String
  }

  connect() {
    const ad = document.querySelector('.mapboxgl-ctrl-geocoder--powered-b')

    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,locality,neighborhood,address",
      placeholder: this.addressValue ? this.addressValue : '*Adresse de facturation',
      countries: 'FR',
      language: 'fr',
      addressAccuracy: "address"
    })
    this.geocoder.addTo('#autocomplete-div')
    this.geocoder.on("result", event => this.#setInputValue(event))
    this.geocoder.on("clear", () => this.#clearInputValue())

    if (this.geocoder._inputEl.placeholder === "Chercher" || this.geocoder._inputEl.placeholder === "*Adresse de facturation") {
      this.geocoder._inputEl.classList.remove('filled')
    } else {
      this.geocoder._inputEl.classList.add('filled')
    }
  }

  #setInputValue(event) {
    this.addressTarget.value = event.result["place_name"]
  }

  #clearInputValue() {
    this.addressTarget.value = ""
  }
}
