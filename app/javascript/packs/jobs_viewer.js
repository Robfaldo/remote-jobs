import {updateJobs} from "../update_jobs";

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
        // By default show all jobs from today that require experience and stem degrees
        document.getElementById('js-experience-tag-checkbox').classList.add('checked-tag');
        document.getElementById('js-stem-degree-tag-checkbox').classList.add('checked-tag');
        document.getElementById('js-show-all-jobs').classList.remove('checked-date-filter');
        document.getElementById('js-posted-today').classList.add('checked-date-filter');
        updateJobs()
});
