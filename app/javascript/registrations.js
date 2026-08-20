// app/assets/javascripts/registrations.js

$(document).on('turbolinks:load', function() {
  $('#unit-code-select').change(function() {
    var unitId = $(this).val();
    if (unitId !== '') {
      $.ajax({
        url: '/units/' + unitId + '.json',
        method: 'GET',
        dataType: 'json',
        success: function(data) {
          $('#unit-name-field').val(data.name); // Update unit name field with the selected unit's name
        },
        error: function() {
          console.error('Error fetching unit details.');
        }
      });
    } else {
      $('#unit-name-field').val(''); // Clear unit name field if no unit is selected
    }
  });
});
