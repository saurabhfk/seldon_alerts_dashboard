// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require_tree .
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
