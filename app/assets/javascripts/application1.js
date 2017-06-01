// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require underscore
//= require underscore.string
//= require zeroclipboard
//= require backbone
//= require select2
//= require jquery.tablesorter.js
//= require jquery.cookie.js
//= require jquery.sortable.js
//= require_self

_.mixin(s.exports());
$.cookie.json = true;

window.reloadClipboard = function(){
var client = new ZeroClipboard( $(".btn-clipboard") );

client.on( 'ready', function(event) {

  client.on( 'aftercopy', function(event) {
    $(event.target).attr("title","Copied!").tooltip("fixTitle").tooltip("show").attr("title","Copy to clipboard").tooltip("fixTitle");
//    console.log('Copied text to clipboard: ' + event.data['text/plain']);
  } );

} );
}


window.FAYE = new Faye.Client(NOTIFICATION_URL);

// $(".btn-clipboard").tooltip({placement: 'right', trigger: 'hover focus', title: "Copy to clipboard"});

