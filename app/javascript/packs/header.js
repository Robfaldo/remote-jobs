window.addEventListener('turbolinks:load', function() {
    $(".js-burger").click(function () {
        if ($(".js-header-text").is(":hidden")) {
            $('.js-header-text').show()
            console.log('show')
        } else {
            $('.js-header-text').hide()
            console.log('hide')
        }
    });
});
