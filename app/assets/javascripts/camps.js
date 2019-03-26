$(document).ready(function() {
  $("#responsibles a.add_fields").
    data("association-insertion-position", 'before').
    data("association-insertion-node", 'this');

  $('#responsibles').on('cocoon:after-insert',
    function() {
     $(".project-tag-fields a.add_fields").
         data("association-insertion-position", 'before').
         data("association-insertion-node", 'this');
     $('.responsible-fields').on('cocoon:after-insert',
          function() {
            $(this).children(".responsible_from_list").remove();
            $(this).children("a.add_fields").hide();
          });
    });

  $('#responsibles').bind('cocoon:before-insert', function(e,el) {
    el.fadeIn('slow');
  });

  $('#responsibles').bind('cocoon:before-remove', function(e, el) {
    $(this).data('remove-timeout', 1000);
    el.fadeOut('slow');
  });

  $('.budgetprogressbar').budgetprogressbar();

  Filterrific.init();
});

$(document).ready(function() {
  $(".best_in_place").best_in_place();
});
