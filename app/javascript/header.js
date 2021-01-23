window.addEventListener('turbolinks:load', function() {
    // alert button
    if ($(".js-close-alert").length > 0) {
        setInterval(function(){
            $(".js-close-alert").click()
        }, 3000);

        $(".js-close-alert").click(function() {
            $(".js-flash-container").hide()
        })
    }
    ////////
});
