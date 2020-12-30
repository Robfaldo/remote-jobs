window.addEventListener('DOMContentLoaded', () => {
    // Everything in here will be executed on page load!

    const dateRangeCheckboxes = document.getElementsByClassName('js-date-range-checkbox');
    const dateRangeCheckboxesArray = [].slice.call(dateRangeCheckboxes);

    const tagCheckboxes =  document.getElementsByClassName('js-experience-tag-checkbox');
    const tagCheckboxesArray = [].slice.call(tagCheckboxes);

    // Add event Listeners
    dateRangeCheckboxesArray.forEach(function(checkbox){
        checkbox.addEventListener('click', updateDateRange, false)
    });

    tagCheckboxesArray.forEach(function(checkbox){
        checkbox.addEventListener('click', updateTag, false)
    });

    // Run this so that it hides the jobs that require experience/degrees etc.. and updates the job count
    updateJobs();

    // Methods triggered by the onclick events
    function updateDateRange() {
        updateDateRangeFilters(this, dateRangeCheckboxesArray);
        updateJobs();
    }

    function updateTag() {
        updateDateTag(this);
        updateJobs();
    }
});

function updateDateRange() {
    updateDateRangeFilters(this, dateRangeCheckboxesArray);
    updateJobs();
}

function updateTag() {
    updateDateTag(this);
    updateJobs();
}

function updateJobs() {
    let jobsNodeList = document.getElementsByClassName('js-job');
    let jobsArray = [].slice.call(jobsNodeList);

    const selectedDateRange = getSelectedDateRange();
    const selectedTags = getSelectedTags();

    let visibleJobsCount = 0;

    jobsArray.forEach(function(jobElement){
        const job = new Job(jobElement);

        if (jobMatchesSelectedDateRange(job, selectedDateRange)) {
            job.matches_selected_date_range = true;
        }

        if (jobMatchesSelectedTags(job, selectedTags)) {
            job.matches_selected_tags = true;
        }

        updateJobListing(job);

        if (job.element_visible) {
            visibleJobsCount++;
        }
    });

    updateJobsFoundCount(visibleJobsCount);
}

function Job(element) {
    this.element = element;
    this.requires_experience = doesJobRequireExperience(this);
    this.requires_stem_degree = doesJobRequireStemDegree(this);
    this.date_range = getDateRange(this);
    this.matches_selected_date_range = false;
    this.element_visible = false;
    this.matches_selected_tags = false;
}

function jobMatchesSelectedDateRange(job, selectedDateRange) {
    const filtersMapping = {
        'js-posted-today': ['js-posted-today'],
        'js-posted-three-days': ['js-posted-three-days'],
        'js-show-all-jobs': ['js-posted-today', 'js-posted-over-three-days', 'js-posted-three-days']
    };

    const jobDateRangesAllowed = filtersMapping[selectedDateRange];

    return jobDateRangesAllowed.includes(job.date_range);
}

function jobMatchesSelectedTags(job, selectedTags) {
    let requiredTags = [];

    if (job.requires_experience) {
        requiredTags.push('js-experience-tag-checkbox');
    }

    if (job.requires_stem_degree) {
        requiredTags.push('js-stem-degree-tag-checkbox');
    }

    if (job.requires_experience && job.requires_stem_degree) {
        return (ArraysMatch(requiredTags, selectedTags) ? true : false);
    } else if (job.requires_experience) {
        return (selectedTags.includes('js-experience-tag-checkbox') ? true : false);
    } else if (job.requires_stem_degree) {
        return (selectedTags.includes('js-stem-degree-tag-checkbox') ? true : false);
    } else {
        return true;
    }
}

function ArraysMatch(first, second) {
    return JSON.stringify(first.sort()) === JSON.stringify(second.sort());
}

function getSelectedDateRange() {
    const dateFiltersElements = document.getElementsByClassName('js-date-range-checkbox');
    const dateFiltersElementsArray = [].slice.call(dateFiltersElements);

    const dateRangeSelected = dateFiltersElementsArray.filter(element => element.classList.contains('checked-date-filter'))[0].id;

    return dateRangeSelected;
}

function getSelectedTags() {
    let tagsElementsToApply = document.getElementsByClassName('checked-tag');
    let tagsToApplyArray = [].slice.call(tagsElementsToApply);

    return tagsToApplyArray.map(element => element.id);
}

function getDateRange(job) {
    const possibleJobDateRanges = ["js-posted-today", "js-posted-three-days", "js-posted-over-three-days"];

    const dateRangesOnJob = possibleJobDateRanges.filter(dateRange => job.element.classList.contains(dateRange));

    return dateRangesOnJob[0];
}

function doesJobRequireStemDegree(job) {
    let tagOnJob = job.element.querySelector('.js-stem-degree-job-tag');

    return (tagOnJob ? true : false);
}

function doesJobRequireExperience(job) {
    let experienceTagOnJob = job.element.querySelector('.js-experience-job-tag');

    return (experienceTagOnJob ? true : false);
}

function updateDateRangeFilters(dateFilterClicked, dateRangeCheckboxesArray) {
    // uncheck them all
    dateRangeCheckboxesArray.forEach(function(checkbox){
        if (checkbox.classList.contains('checked-date-filter')) {
            checkbox.classList.remove('checked-date-filter');
        }
    });

    // Check the box that was clicked
    dateFilterClicked.classList.add('checked-date-filter');
}

function updateDateTag(tagClicked) {
    // toggle the checkbox
    if (tagClicked.classList.contains('checked-tag')) {
        tagClicked.classList.remove('checked-tag');
    } else {
        tagClicked.classList.add('checked-tag');
    }
}

function updateJobListing(job) {
    if (job.matches_selected_date_range && job.matches_selected_tags) {
        makeVisible(job);
    } else {
        makeInvisible(job);
    }
}

function makeVisible(job) {
    job.element.style.display = "";
    job.element_visible = true;
}

function makeInvisible(job) {
    job.element.style.display = "none";
    job.element_visible = false;
}

function updateJobsFoundCount(visibleJobsCount) {
    document.getElementsByClassName('jobs-count')[0].textContent = visibleJobsCount;
}
