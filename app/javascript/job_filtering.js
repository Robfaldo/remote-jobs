window.addEventListener('DOMContentLoaded', () => {
    let education_dropdown = document.getElementById('js-learning-background');

    let stacksCheckboxes = document.getElementById('js-stack-checkboxes');

    let replaceCurrentJobListingsDiv = function(){
        // get the current job listings div and remove it
        let jobListingsDiv = document.getElementById('js-job-listings-container')
        let oldDivClassName = jobListingsDiv.className;
        let oldDivId = jobListingsDiv.id; // does this work?
        let parentNode = jobListingsDiv.parentNode;
        jobListingsDiv.remove()

        // create the new job listings div
        let newDiv = document.createElement("div");
        newDiv.className = oldDivClassName;
        newDiv.id = oldDivId;

        parentNode.appendChild(newDiv);

        return newDiv;
    };

    let calculatePublishedMessage = function(job){
        //calculate how long ago it was posted
        let day_start = new Date(job["published_date"]);
        let day_end = new Date();
        let total_days = (day_end - day_start) / (1000 * 60 * 60 * 24);
        let rounded_total_days =  Math.round(total_days)
        let published_message = ""

        if (total_days > 30) {
            return "Posted over 30 days ago"
        } else if (total_days < 30 && total_days > 1) {
            return "Posted " + rounded_total_days + " days ago"
        } else if (total_days == 1) {
            return "Posted " + rounded_total_days + " day ago"
        } else if (total_days == 0) {
            return "Posted " + rounded_total_days + " days ago"
        }
    }

    let createNewJobs = function(allJobs, stackDivsToInclude){
        let allJobsArray = JSON.parse(allJobs)
        let filteredJobsDivs = [];

        for (let i = 0; i < allJobsArray.length; i++) {
            let job = allJobsArray[i]

            let stacksToInclude = [];
            stackDivsToInclude.forEach(stackCb => stacksToInclude.push(parseInt(stackCb.value.split("_").pop())));

            if (stacksToInclude.includes(job["stack_id"]) != true) {
                continue
            }

            let newJobDiv = document.createElement("div");

            let published_message = calculatePublishedMessage(job);

            newJobDiv.innerHTML =
                '<div class="job-listing">' +
                '<div class="row">' +
                '<div class="col-md-12 col-lg-6">' +
                '<div class="row">' +
                '<div class="col-10">' +
                '<h4 class="job__title"><a href="link">' + job["title"] + '</a></h4>' +
                '<p class="job__company">' + job["company_name"] + '</p>' +
                '</div>' +
                '</div>' +
                '</div>' +
                '<div class="col-10 col-md-3 col-lg-3 ml-auto">' +
                '<p>' + job["location"] + '</p>' +
                '</div>' +
                '<div class="col-10 col-md-3 col-lg-3 ml-auto">' +
                '<p>' + published_message + '</p>' +
                '</div>' +
                '</div>' +
                '</div>'

            filteredJobsDivs.push(newJobDiv);
        }

        return filteredJobsDivs
    };

    let attachNewJobsToJobListings = function(newDiv, filteredJobsDivs) {
        for (let i = 0; i < filteredJobsDivs.length; i++) {
            newDiv.appendChild(filteredJobsDivs[i]);
        }
    };

    let updateJobsCount = function(filteredJobsDivs){
        let jobs_count = document.getElementById('js-jobs-count');
        jobs_count.textContent = filteredJobsDivs.length
    }

    stacksCheckboxes.addEventListener('change', function (){
        let stackDivsToInclude = document.querySelectorAll('input[name="js-stacks-cb"]:checked');

        let newJobListingsDiv = replaceCurrentJobListingsDiv();

        let filteredJobsDivs = createNewJobs(allJobs, stackDivsToInclude);

        attachNewJobsToJobListings(newJobListingsDiv, filteredJobsDivs);

        updateJobsCount(filteredJobsDivs);
    });
})