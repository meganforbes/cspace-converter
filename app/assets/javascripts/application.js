// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

var ready;
ready = function() {
  // set the filename when selected
  var file = "#file";
  $(file).change(function() {
    var absolute_name = $(file).val();
    var parts         = absolute_name.split('\\');
    var filename      = parts[parts.length - 1];
    $('.file span').replaceWith('<p class="file-selected">' + filename + '</p>');
  });
};

// turbolinks friendly
$(document).ready(ready);
$(document).on('page:load', ready);
