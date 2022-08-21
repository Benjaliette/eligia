import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home-infos-appear"
export default class extends Controller {
  static targets = [ "timelineItems", "checkpoints", "infoItems", "arrowLeft", "arrowRight" ]

  transition(event) {
    if(Array.from(event.srcElement.classList).includes('next') || Array.from(event.srcElement.parentElement.classList).includes('next')) {
      this.slideLeft(this.timelineItemsTargets)
      this.slideLeft(this.infoItemsTargets)
      this.slideLeft(this.checkpointsTargets)

      this.arrowLeftTarget.classList.remove('disabled')

      if(this.infoItemsTargets.filter(infoItem => Array.from(infoItem.classList).includes('next')).length === 0) {
        this.arrowRightTarget.classList.add('disabled')
      }
    } else if(Array.from(event.srcElement.classList).includes('prev') || Array.from(event.srcElement.parentElement.classList).includes('prev')) {
      this.slideRight(this.timelineItemsTargets)
      this.slideRight(this.infoItemsTargets)
      this.slideRight(this.checkpointsTargets)

      this.arrowRightTarget.classList.remove('disabled')

      if(this.infoItemsTargets.filter(infoItem => Array.from(infoItem.classList).includes('prev')).length === 0) {
        this.arrowLeftTarget.classList.add('disabled')
      }
    }

  }

  transitionLeft(event) {
    if(!(Array.from(event.srcElement.classList).includes('disabled'))) {
      this.slideRight(this.timelineItemsTargets)
      this.slideRight(this.infoItemsTargets)
      this.slideRight(this.checkpointsTargets)
    }

    this.arrowRightTarget.classList.remove('disabled')

    if(this.infoItemsTargets.filter(infoItem => Array.from(infoItem.classList).includes('prev')).length === 0) {
      this.arrowLeftTarget.classList.add('disabled')
    }
  }

  transitionRight(event) {
    if(!(Array.from(event.srcElement.classList).includes('disabled'))) {
      this.slideLeft(this.timelineItemsTargets)
      this.slideLeft(this.infoItemsTargets)
      this.slideLeft(this.checkpointsTargets)
    }

    this.arrowLeftTarget.classList.remove('disabled')

    if(this.infoItemsTargets.filter(infoItem => Array.from(infoItem.classList).includes('next')).length === 0) {
      this.arrowRightTarget.classList.add('disabled')
    }
  }

  slideLeft(array) {
    array.forEach((item) => {
      if(Array.from(item.classList).includes('active')) {
        item.classList.remove('active')
        item.classList.add('prev')
      } else if(Array.from(item.classList).includes('next')) {
        item.classList.remove('next')
        item.classList.add('active')
      } else if(Array.from(item.classList).includes('next-transparent')) {
        item.classList.remove('next-transparent')
        item.classList.add('next')
      } else if(Array.from(item.classList).includes('prev')) {
        item.classList.remove('prev')
        item.classList.add('prev-transparent')
      } else {
        item.classList.add('next')
      }
    })
  }

  slideRight(array) {
    array.forEach((item) => {
      if(Array.from(item.classList).includes('active')) {
        item.classList.remove('active')
        item.classList.add('next')
      } else if(Array.from(item.classList).includes('next')) {
        item.classList.remove('next')
        item.classList.add('next-transparent')
      } else if(Array.from(item.classList).includes('prev')) {
        item.classList.remove('prev')
        item.classList.add('active')
      } else if(Array.from(item.classList).includes('prev-transparent')) {
        item.classList.remove('prev-transparent')
        item.classList.add('prev')
      } else {
        item.classList.add('prev')
      }
    })
  }
}
