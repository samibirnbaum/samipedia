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
//= require jquery3
//= require popper
//= require bootstrap
document.addEventListener("turbolinks:load", function() {
    $(document).ready(function(){
        $('#premium-button').popover({
            container: 'body',
            animation: true,
            trigger: 'hover',
            title: "Premium Account",
            content: "Gives you access to Private Wikis"
            });
    });

    $("#downgrade-button").click(function(){
        return confirm("Warning:\n\nIf you continue your account will be downgraded and you will no longer have access to private wikis. \n\nAll your current private wikis will be automatically made public.");
    });
})