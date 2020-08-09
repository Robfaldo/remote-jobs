import $ from 'jquery'
import 'select2'
import 'select2/dist/css/select2.css'

window.addEventListener('DOMContentLoaded', () => {
    $('.js-technologies').select2({
        multiple: true,
        width: '100%'
    })
})

// https://select2.org/configuration for the different options that can be passed to select2

