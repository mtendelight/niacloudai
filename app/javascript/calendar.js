import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import interactionPlugin from "@fullcalendar/interaction";

document.addEventListener("DOMContentLoaded", () => {
  const calendarEl = document.getElementById("calendar");

  if (calendarEl) {
    const calendar = new Calendar(calendarEl, {
      plugins: [dayGridPlugin, interactionPlugin],

      initialView: "dayGridMonth",

      events: "/calendar_events",

      selectable: true,

      select(info) {
        const title = prompt("Event Title");

        if (title) {
          fetch("/jevents", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
            },
            body: JSON.stringify({
              jevent: {
                title: title,
                start: info.start,
                end: info.end
              }
            })
          }).then(() => calendar.refetchEvents());
        }
      },

      eventClick(info) {
        alert(info.event.title);
      },

      editable: true,

      eventDrop(info) {
        updateEvent(info.event);
      },

      eventResize(info) {
        updateEvent(info.event);
      }
    });

    calendar.render();

    function updateEvent(event) {
      fetch(`/jevents/${event.id}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: JSON.stringify({
          jevent: {
            start: event.start,
            end: event.end
          }
        })
      });
    }
  }
});