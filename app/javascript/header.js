window.addEventListener('turbolinks:load', function() {
    $(".js-burger").click(function () {
        if ($(".js-header-text").is(":hidden")) {
            $('.js-header-text').show()
            $('.js-main-nav-list').hide()
        } else {
            $('.js-header-text').hide()
            $('.js-main-nav-list').show()
        }
    });
});
