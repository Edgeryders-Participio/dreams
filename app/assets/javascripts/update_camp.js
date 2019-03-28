$(document).ready(function() {

    $('#save-camp').click(function() {
        $('#camp-form').submit();
    });

    $('#done-camp').click(function() {
        $('#camp-form').append('<input type="hidden" name="done" value="1" />');
        $('#camp-form').submit();
    });

    $('#save-safety').click(function() {
        $('#safety-form').append('<input type="hidden" name="safetysave" value="1" />');
        $('#safety-form').submit();
    });

    $('#done-safety').click(function() {
        $('#safety-form').append('<input type="hidden" name="done" value="1" />');
        $('#safety-form').submit();
    });
});