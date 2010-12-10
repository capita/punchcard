// Update status for all people
function update_status() {
  var in_office = [];
  $.getJSON('/status.json', function(json) {
    $.each(json.people, function(index, person) {
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
  $('abbr.timeago').timeago();
  update_title();
};

// Update page title based upon people present in office
function update_title() {
  title = 'Punchcard.'
  if ($('.gravatar.pending').size() > 0) {
    title = 'In office: ' + $('.gravatar.pending').map(function() {
      return $(this).attr('title').replace(/[^A-Z]/g, '');
    }).get().join(', ');
  }
  $('head title').html(title);
}

$(document).ready(function() {
  $( "#personTemplate" ).template( "personTemplate" );
  
  $('#people li').live('dblclick', function() {
    user_id = $(this).attr('id');
    $.post('/punch/' + user_id, function(data) {
      //$('.result').html(data);
      var json = jQuery.parseJSON(data);
      update_person(json);
    });
  });
  
  update_status();
  var timer = setInterval( update_status, 5000);
});