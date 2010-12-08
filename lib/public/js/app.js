function update_user_status(json) {
  var status_container = $('#' + json._id + ' .gravatar');
  if (json.pending == true) {
    status_container.addClass('pending');
  } else {
    status_container.removeClass('pending');
  };
};

$(document).ready(function() {
  $('#people li').live('click', function() {
    user_id = $(this).attr('id');
    $.post('/punch/' + user_id, function(data) {
      //$('.result').html(data);
      var json = jQuery.parseJSON(data);
      update_user_status(json);
    });
  });
});