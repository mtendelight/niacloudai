// app/javascript/controllers/nested_form_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["items", "template"]

  addItem(event) {
    event.preventDefault()
    // Replace TEMPLATE_RECORD with a unique timestamp
    const time = new Date().getTime()
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, time)
    this.itemsTarget.insertAdjacentHTML("beforeend", content)
  }

  removeItem(event) {
    event.preventDefault()
    const item = event.target.closest(".nested-item")
    if(item.dataset.newRecord === "true") {
      // If newly added item, just remove from DOM
      item.remove()
    } else {
      // If existing record, mark _destroy for Rails
      const destroyInput = item.querySelector("input[name*='_destroy']")
      if(destroyInput) {
        destroyInput.value = 1
        item.style.display = "none"
      }
    }
  }

  calculateAmount(event) {
    const row = event.target.closest(".nested-item")
    const quantity = parseFloat(row.querySelector("[name*='quantity']").value) || 0
    const unitPrice = parseFloat(row.querySelector("[name*='unit_price']").value) || 0
    const amountField = row.querySelector("[name*='amount']")
    amountField.value = (quantity * unitPrice).toFixed(2)
  }
}