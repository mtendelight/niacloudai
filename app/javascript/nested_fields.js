document.addEventListener("DOMContentLoaded", () => {
  document.addEventListener("click", function(event) {
    if (event.target.matches(".remove_fields")) {
      event.preventDefault();
      let field = event.target.closest(".nested-fields");
      field.querySelector("input[name*='_destroy']").value = 1;
      field.style.display = "none";
    }
    
    if (event.target.matches(".add_fields")) {
      event.preventDefault();
      let time = new Date().getTime();
      let regexp = new RegExp(event.target.dataset.id, "g");
      let newFields = event.target.dataset.fields.replace(regexp, time);
      event.target.insertAdjacentHTML("beforebegin", newFields);
    }
  });
});
