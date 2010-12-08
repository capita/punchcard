// Update status for all people
function update_status() {
  $.getJSON('/status.json', function(json) {
    $.each(json, function(index, person) {
      update_person(person);
    });
  });
};

// Render the state of the person from given json
function update_person(json) {
  var rendered_template = $.tmpl('personTemplate', json);
  
  if ($('#people #' + json._id).size() == 0) {
    rendered_template.appendTo('#people');
  } else {
    $('#people #' + json._id).replaceWith(rendered_template);
  };
};

$(document).ready(function() {
  $( "#personTemplate" ).template( "personTemplate" );
  
  $('#people li').live('click', function() {
    user_id = $(this).attr('id');
    $.post('/punch/' + user_id, function(data) {
      //$('.result').html(data);
      var json = jQuery.parseJSON(data);
      update_person(json);
    });
  });
  
  update_status();
});