window.addEventListener('DOMContentLoaded', () => {
    const rejectedReasons = document.getElementsByClassName('js-show-rejected-reason');
    const rejectedReasonsArray = [].slice.call(rejectedReasons);

    rejectedReasonsArray.forEach(function(checkbox){
        checkbox.addEventListener('click', toggleRejectedReason, false)
    });

    function toggleRejectedReason() {
        const reason = this.getElementsByClassName('js-rejected-reason')[0];

        if (reason.classList.contains('show-rejected-reason')) {
            reason.classList.remove('show-rejected-reason')
            reason.classList.add('hide-rejected-reason')
        } else {
            reason.classList.add('show-rejected-reason')
            reason.classList.remove('hide-rejected-reason')
        }
    }
});
