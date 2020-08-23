window.addEventListener('DOMContentLoaded', () => {
    let education_dropdown = document.getElementById('js-learning-background');

    education_dropdown.addEventListener('change', function (){
        education_selection = education_dropdown.value

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

            if (job["level_id"] != education_selection) {
                continue;
            }
            let newJobDiv = document.createElement("div");

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
                '<p>Posted TIME ago</p>' +
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
    });


})