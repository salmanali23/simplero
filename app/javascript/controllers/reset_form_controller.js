import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    super.connect()
  }

  reset() {
    this.element.reset();
  }
  
  hide(event){
    event.preventDefault();
    event.stopPropagation();
    this.element.innerHTML = ''
  }
}