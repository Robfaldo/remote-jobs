window.addEventListener('DOMContentLoaded', () => {
    let education_dropdown = document.getElementById('js-learning-background');

    education_dropdown.addEventListener('change', function (){
        education_selection = education_dropdown.value

        // If they choose any educational background then turn the placeholder to a 'show all jobs' option
        let showAllJobs = true
        if (education_selection != "") {
            let dropdown_options= document.getElementById('js-learning-background').options
            dropdown_options[0].textContent = "Show me all jobs"
            showAllJobs = false;
        }

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

        // Create the new jobs
        let allJobsArray = JSON.parse(allJobs)
        let filteredJobsDivs = [];

        for (let i = 0; i < allJobsArray.length; i++) {
            let job = allJobsArray[i]

            if (showAllJobs == false && job["level_id"] != education_selection) {
                continue;
            }

            let newJobDiv = document.createElement("div");

            //calculate how long ago it was posted
            let day_start = new Date(job["published_date"]);
            let day_end = new Date();
            let total_days = (day_end - day_start) / (1000 * 60 * 60 * 24);
            let rounded_total_days =  Math.round(total_days)
            let published_message = ""

            if (total_days > 30) {
                published_message = "Posted over 30 days ago"
            } else if (total_days < 30 && total_days > 1) {
                published_message = "Posted " + rounded_total_days + " days ago"
            } else if (total_days == 1) {
                published_message = "Posted " + rounded_total_days + " day ago"
            } else if (total_days == 0) {
                published_message = "Posted " + rounded_total_days + " days ago"
            }

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
                '<p>' + published_message + '</p>' +
                '</div>' +
                '</div>' +
                '</div>'

            filteredJobsDivs.push(newJobDiv);
        }

        // Attach the new job to the new job listing div
        for (let i = 0; i < filteredJobsDivs.length; i++) {
            newDiv.appendChild(filteredJobsDivs[i]);
        }

        parentNode.appendChild(newDiv);

        // Update the jobs count
        let jobs_count = document.getElementById('js-jobs-count');
        jobs_count.textContent = filteredJobsDivs.length
    });


})