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

  // hide the profile options that do not belong to the converter (start with Default)
  $("#profile option[class!='Default']").hide();
  var converter = "#module";
  $(converter).change(function() {
    // start by deselecting all the options
    $("#profile option").attr("selected", false);

    // get the the selected converter and show its options, selecting the 1st visible
    var selected = $(converter + " option:selected").text();
    $("#profile option[class='"  + selected + "']").show();
    $("#profile option[class='"  + selected + "']:first").attr("selected", true);

    // hide all the options not belonging to this converter
    $("#profile option[class!='" + selected + "']").hide();
  });

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
