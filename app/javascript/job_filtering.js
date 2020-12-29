window.addEventListener('DOMContentLoaded', () => {
    const dateRangeCheckBoxes = ['posted-today', 'show-all-jobs', 'posted-three-days'];

    let checkboxes = document.getElementsByClassName('filter-box');

    for (let i = 0; i < checkboxes.length; i++) {
        checkboxes[i].addEventListener('click', update, false);
    };

    function update() {
        updateDateRangeFilters(this);

        let jobsNodeList = document.getElementsByClassName('job');
        let jobElements = [].slice.call(jobsNodeList);

        let visibleJobsCount = 0;

        jobElements.forEach(function(jobElement){
            const job = new Job(jobElement);
            const dateFilterToInclude = getDateFiltersToApply();

            job.updateDateRange(dateFilterToInclude);
            updateJobListing(job) // need to increment visible jobs after we update

            if (job.elementVisible) {
                visibleJobsCount++;
            }
        });

        updateJobsFoundCount(visibleJobsCount);
    }

    function Job(element) {
        this.element = element
        this.tags = getJobTags(element);
        this.dateRange = getDateRange(element);
        this.visibility = '';
        this.dateRangeSelected = false;

        this.updateDateRange = updateDateRange
    }

    function getJobTags(job) {
        let allJobTagsElements = job.querySelectorAll('.tag');
        let allJobTagsElementsArray = [].slice.call(allJobTagsElements);

        return allJobTagsElementsArray
    }

    function getDateRange(job) {
        const possibleDateRanges = ['posted-today', 'show-all-jobs', 'posted-three-days'];

        return possibleDateRanges.filter(dateRange => job.classList.contains(dateRange))[0];
    }

    function updateDateRange(dateFilterSeleted) {
        if (jobMatchesDateFilter(dateFilterSeleted, this)) {
            this.dateRangeSelected = true
        }

    }

    function getDateFiltersToApply() {
        let dateFiltersElements = document.getElementsByClassName('date-filter');
        let dateFiltersElementsArray = [].slice.call(dateFiltersElements);

        return dateFiltersElementsArray.filter(element => element.classList.contains('checked-filter'))[0].id;
    }

    function jobMatchesDateFilter(dateFilterSeleted, job) {
        const filtersMapping = {
            // class of filter : class of job
            'posted-today': ['posted-today'],
            'posted-three-days': ['posted-three-days'],
            'show-all-jobs': ['posted-today', 'posted-over-three-days', 'posted-three-days']
        };

        let jobDateRangesThatWouldMatch = filtersMapping[dateFilterSeleted];

        return dateRangeMatches(jobDateRangesThatWouldMatch, job)
    }

    function dateRangeMatches(dateRanges, job) {
        let matchedFilters = 0;

        dateRanges.forEach(function(dateRange) {
            if (job.element.classList.contains(dateRange)) {
                matchedFilters++
            }
        });

        return matchedFilters > 0
    }

    function updateDateRangeFilters(dateRangeClicked) {
        // uncheck them all
        for (let i = 0; i < dateRangeCheckBoxes.length; i ++) {
            let checkBox = document.getElementById(dateRangeCheckBoxes[i]);
            if (checkBox.classList.contains('checked-filter')) {
                checkBox.classList.remove('checked-filter');
            }
        }

        // Check the box that was clicked
        if (!dateRangeClicked.classList.contains('checked-filter')) {
            dateRangeClicked.classList.add('checked-filter');
        }
    }

    function updateJobListing(job) {
        if (job.dateRangeSelected == true) {
            job.element.style.display = "";
            job.elementVisible = true;
        } else {
            job.element.style.display = "none";
            job.elementVisible = false;
        }
    }

    function updateJobsFoundCount(visibleJobsCount) {
        document.getElementsByClassName('jobs-count')[0].textContent = visibleJobsCount;
    }
    // for each job
        // if it is within the selected date range
        // if it has a tag
            // if the tag is selected












    // let dateRangeCheckBoxes = ['posted-today', 'show-all-jobs', 'posted-three-days'];
    //
    // const filtersMapping = {
    //     'posted-today': ['posted-today'],
    //     'posted-three-days': ['posted-three-days'],
    //     'show-all-jobs': ['posted-today', 'posted-over-three-days', 'posted-three-days']
    // };
    //
    // const tagsMapping = {
    //     'requires-experience-filter': 'requires-experience',
    //     'requires-stem-degree-filter': 'requires-stem-degree'
    // };
    //
    // const updateCheckboxes = function() {
    //     if (isDateRangeFilter(this.id)) {
    //         updateDateRangeFilterBoxes(this);
    //     } else {
    //         updateTagFilterBoxes(this);
    //     }
    //
    //     let tagsToApply = getTagsToApply();
    //     let dateFilterToApply = getDateFilterToApply();
    //
    //     filterJobs(dateFilterToApply, tagsToApply);
    // };
    //
    // const filterJobs = function(dateFilterToApply, tagsToApply) {
    //     let jobs = document.getElementsByClassName('job');
    //     let visibleElements = 0;
    //
    //     for (let i = 0; i < jobs.length; i++) {
    //         const job = jobs[i];
    //
    //         let jobDateFiltersRequired = filtersMapping[dateFilterToApply];
    //
    //         let jobTagsRequired = [];
    //         tagsToApply.forEach(tag => jobTagsRequired.push(tagsMapping[tag]));
    //
    //         if (dateRangeisIncluded(jobDateFiltersRequired, job)) {
    //             if (jobHasNoTags(job) || tagIsSelected(jobTagsRequired, job)) {
    //                 jobs[i].style.display = "";
    //                 visibleElements++;
    //             }
    //         } else {
    //             jobs[i].style.display = "none";
    //         }
    //
    //     }
    //
    //     document.getElementsByClassName('jobs-count')[0].textContent = visibleElements;
    // }
    //
    // const getDateFilterToApply = function() {
    //     let dateFiltersElements = document.getElementsByClassName('date-filter');
    //     let dateFiltersElementsArray = [].slice.call(dateFiltersElements);
    //     return dateFiltersElementsArray.filter(element => element.classList.contains('checked-filter'))[0].id;
    // }
    //
    // const getTagsToApply = function() {
    //     let tagsElementsToApply = document.getElementsByClassName('checked-tag');
    //     let tagsToApplyArray = [].slice.call(tagsElementsToApply);
    //
    //     return tagsToApplyArray.map(element => element.id);
    // }
    //
    // const updateDateRangeFilterBoxes = function(dateRangeFilterClicked) {
    //     // uncheck them all
    //     for (let i = 0; i < dateRangeCheckBoxes.length; i ++) {
    //         let checkBox = document.getElementById(dateRangeCheckBoxes[i]);
    //         if (checkBox.classList.contains('checked-filter')) {
    //             checkBox.classList.remove('checked-filter');
    //         }
    //     }
    //
    //     // Check the box that was clicked
    //     if (!dateRangeFilterClicked.classList.contains('checked-filter')) {
    //         dateRangeFilterClicked.classList.add('checked-filter');
    //     }
    // };
    //
    // const updateTagFilterBoxes = function(tagFilterClicked) {
    //     // toggle the checkbox
    //     if (tagFilterClicked.classList.contains('checked-tag')) {
    //         tagFilterClicked.classList.remove('checked-tag')
    //     } else {
    //         tagFilterClicked.classList.add('checked-tag')
    //     }
    // };
    //
    // const dateRangeisIncluded = function(datesRangesToInclude, job) {
    //     let matchedFilters = 0;
    //
    //     datesRangesToInclude.forEach(function(dateRange) {
    //         if (job.classList.contains(dateRange)) {
    //             matchedFilters++
    //         }
    //     });
    //
    //     if (matchedFilters > 0) {
    //         console.log('dateRangeIsIncluded')
    //     }
    //
    //     return matchedFilters > 0
    // }
    //
    // const tagIsSelected = function(selectedTags, job) {
    //     let allJobTagsElements = job.querySelectorAll('.tag');
    //     let allJobTagsElementsArray = [].slice.call(allJobTagsElements);
    //
    //     let matchedTags = 0;
    //
    //     selectedTags.forEach(function(tag) {
    //         allJobTagsElementsArray.forEach(function(el) {
    //             if (el.classList.contains(tag)) {
    //                 matchedTags++;
    //             }
    //         })
    //     });
    //
    //     return matchedTags.length > 0;
    // };
    //
    // const jobHasNoTags = function(job) {
    //     let allJobTagsElements = job.querySelectorAll('.tag');
    //     let allJobTagsElementsArray = [].slice.call(allJobTagsElements);
    //
    //     let possibleTags = Object.values(tagsMapping);
    //
    //     let matchedTags = 0;
    //
    //     possibleTags.forEach(function(possibleTag) {
    //         allJobTagsElementsArray.forEach(function(jobTag) {
    //             if (jobTag.classList.contains(possibleTag)) {
    //                 matchedTags++
    //             }
    //         })
    //     });
    //
    //     if (matchedTags > 0) {
    //         console.log("Job has tags")
    //     }
    //
    //     return matchedTags == 0
    // };
    //
    // const isDateRangeFilter = function(id) {
    //     return dateRangeCheckBoxes.includes(id);
    // };
    //
    // let checkBoxes = document.getElementsByClassName('filter-box');
    //
    // for (let i = 0; i < checkBoxes.length; i++) {
    //     checkBoxes[i].addEventListener('click', updateCheckboxes, false);
    // }
});
