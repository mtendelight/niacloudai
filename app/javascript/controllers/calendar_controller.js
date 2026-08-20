import { Controller } from "@hotwired/stimulus"
import { Calendar } from "@fullcalendar/core"
import dayGridPlugin from "@fullcalendar/daygrid"
import interactionPlugin from "@fullcalendar/interaction"

export default class extends Controller {
  connect() {
    new Calendar(this.element, {
      plugins: [dayGridPlugin, interactionPlugin],
      initialView: "dayGridMonth",
      events: "/events.json", // <-- fetch all events here
      height: "auto",
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,dayGridWeek,dayGridDay"
      }
    }).render()
  }
}