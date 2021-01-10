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

    // Update ajax calls (made with the links_to in the erb file, we bind the ajax:success/error to the element so that it's triggered when the server responds to the call. https://guides.rubyonrails.org/working_with_javascript_in_rails.html
    $('.js-status-update').bind('ajax:error', function(event) {
        const [data, status, xhr] = event.detail;
        // Currently doing nothing
    });

    $('.js-status-update').bind('ajax:success', function(response) {
        const [data, status, xhr] = event.detail;

        this.querySelector('.update-status').style.backgroundColor = "#42c2bb"
        this.querySelector('.update-status').style.color = "white"
    });

    $('.js-experience-update').bind('ajax:error', function(event) {
        const [data, status, xhr] = event.detail;
        // Currently doing nothing
    });

    $('.js-experience-update').bind('ajax:success', function(response) {
        const [data, status, xhr] = event.detail;

        this.querySelector('.update-requirement').style.backgroundColor = "green"
        this.querySelector('.update-requirement').style.color = "white"
    });

    $('.js-mark-as-reviewed').bind('ajax:error', function(event) {
        const [data, status, xhr] = event.detail;
        // Currently doing nothing
    });

    $('.js-mark-as-reviewed').bind('ajax:success', function(response) {
        const [data, status, xhr] = event.detail;

        this.closest('.js-job').classList.add('reviewed');
        let jobsCount = document.getElementsByClassName('jobs-count')[0]
        jobsCount.textContent = parseInt(jobsCount.textContent) - 1;

        let reviewsRemaining = document.getElementsByClassName('js-reviews-remaining')[0];
        reviewsRemaining.textContent = parseInt(reviewsRemaining.textContent) - 1;
    });


    // job review filters
    $('.js-show-reviewed-jobs').click(function(){
        updateReviewedJobs();
    });
});

function updateReviewedJobs() {
    const reviewedJobs = document.getElementsByClassName('reviewed');
    const reviewedJobsArray = [].slice.call(reviewedJobs);

    const showReviewedJobs = document.getElementsByClassName('show-reviewed');
    const showReviewedJobsArray = [].slice.call(showReviewedJobs);


    if (reviewedJobsArray.length > 0) {
        reviewedJobsArray.forEach(function(job){
            job.classList.remove('reviewed');
            job.classList.add('show-reviewed');
        });
    } else if (showReviewedJobsArray.length > 0) {
        showReviewedJobsArray.forEach(function(job){
            job.classList.remove('show-reviewed');
            job.classList.add('reviewed');
        });
    } else {
        console.log('no reviewed jobs')
    }
}
