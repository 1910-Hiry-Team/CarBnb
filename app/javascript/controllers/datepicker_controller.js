import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";

// Connects to data-controller="datepicker"
export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      mode: "range", // Enables range selection
      dateFormat: "d-m-Y", // Format for the selected dates
      minDate: "today", // Optional: Disable past dates
    });
  }
}
