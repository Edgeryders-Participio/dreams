
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

  function getAuthenticityToken(el) {
    return $('input[name=authenticity_token]', $(el).closest('form')).val()
  }

  function getUrl(el) {
    return $(el).closest('form').attr('action');
  }

  function refreshTags(data) {
    $('#tag-container').empty();
    for(var tag in data) {
      $('#tag-container').append(
          '<div class="tag-item">'
          + data[tag].name
          + '<span class="tag-remove" data-tag="'
          + data[tag].name
          + '">x</span>'
          + '</div>'
      );
      $('.tag-remove').click(removeTag);
    }
  }

  function removeTag(e, el) {
    var url = getUrl(e.target);
    var tag = $(e.target).data('tag');
    var token = getAuthenticityToken(e.target);

    $.ajax({
      url: url,
      type: 'POST',
      data: {method:'_patch', 'camp[tag]': tag, authenticity_token:token},
      success: function(data) {
        refreshTags(data);
      }
    })
  }

  function addTags(e, el) {
    var url = getUrl(e.target);
    var tags = $("#camp_tag_list").val();
    var token = getAuthenticityToken(e.target);

    e.preventDefault();

    $.ajax({
      url: url,
      type: 'POST',
      data: {method:'_patch', 'camp[tag_list]': tags, authenticity_token:token},
      success: function(data) {
        refreshTags(data);
      }
    });

    return false;
  }

  $('.tag-remove').click(removeTag);
  $('#tags-add').click(addTags);

});

$(document).ready(function() {
  $(".best_in_place").best_in_place();
});

$(document).ready(function() {

  function showLightbox(event, element) {
    var dreams = [];
    $('.card').each(function(index, value) {
      dreams.push({campId:$(value).data('camp-id'), campImage:$(value).data('camp-image')})
    });

    console.log(dreams, $(event.target).data('camp-id'));

    //get location/size from source div

    //calculate target coordinates

    //from -> to

    return false;
  }

  function closeLightbox() {
    //find target card coords

    //animate delta
  }


  $('.show-lightbox').click(showLightbox)
});
