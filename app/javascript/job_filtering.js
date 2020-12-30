window.addEventListener('DOMContentLoaded', () => {
    const tagsMapping = {
        'requires-experience-filter': 'requires-experience',
        'requires-stem-degree-filter': 'requires-stem-degree'
    };

    const dateRangeCheckBoxes = ['posted-today', 'show-all-jobs', 'posted-three-days'];

    let checkboxes = document.getElementsByClassName('filter-box');

    for (let i = 0; i < checkboxes.length; i++) {
        checkboxes[i].addEventListener('click', update, false);
    };

    function update() {
        if (dateRangeClicked(this)) {
            updateDateRangeFilters(this);
        } else {
            updateTagsFilters(this);
        }

        let jobsNodeList = document.getElementsByClassName('job');
        let jobElements = [].slice.call(jobsNodeList);

        let visibleJobsCount = 0;
        let tagsRequired = requiredTags();

        const dateFilterToInclude = getDateFiltersToApply();
        //
        // let overThree = 0;
        // let today = 0;
        // let lastThree = 0;
        // let dateRangesMatch = 0;
        // let hasFilterTag = 0;

        jobElements.forEach(function(jobElement){
            const job = new Job(jobElement);

            job.updateDateRange(dateFilterToInclude);

            decideIfJobHasTagToFilter(job);
            // console.log(job.hasMatchingTags)

            if (job.hasFilterTag) {
                job.updateJobMeetsTagRequirements(tagsRequired)
                console.log('matching tags: ' + job.hasMatchingTags)
            }

            // console.log('date range: ' + job.dateRange)
            // if (job.dateRange == 'posted-today') {
            //     today++
            // } else if (job.dateRange == 'posted-over-three-days') {
            //     overThree++
            // } else if (job.dateRange == 'posted-three-days') {
            //     lastThree++
            // }
            //
            // if (job.hasFilterTag) {
            //     hasFilterTag++
            // }
            // if (job.dateRangeSelected) {
            //     dateRangesMatch++;
            // }


            updateJobListing(job);

            if (job.elementVisible) {
                visibleJobsCount++;
            }
        });

        // console.log('overThree: ' + overThree)
        // console.log('today: ' + today)
        // console.log('lastThree: ' + lastThree)
        // console.log('dateRangesMatch: ' + dateRangesMatch)
        // console.log('hasFilterTag: ' + hasFilterTag)

        updateJobsFoundCount(visibleJobsCount);
    }

    function Job(element) {
        this.element = element
        this.tags = getJobTags(element);
        this.dateRange = getDateRange(element);
        this.visibility = '';
        this.dateRangeSelected = false;
        this.hasFilterTag = false;
        this.hasMatchingTags = false;

        this.updateDateRange = updateDateRange;
        this.updateJobMeetsTagRequirements = updateTagsMatch;
    }

    function updateTagsMatch(selectedTags) {
        let job = this;
        let matchedSelectedTags = [];

        selectedTags.forEach(function(selectedTag){
            job.tags.forEach(function(tag) {
                if (tag.classList.contains(tagsMapping[selectedTag])) {
                    matchedSelectedTags.push(selectedTag)
                }
            });
        });

        if (ArraysMatch(matchedSelectedTags, selectedTags) && matchedSelectedTags.length == job.tags.length) {
            this.hasMatchingTags = true;
        }
    }

    function ArraysMatch(first, second) {
        return JSON.stringify(first.sort()) === JSON.stringify(second.sort());
    }

    function dateRangeClicked(elementClicked) {
        return dateRangeCheckBoxes.includes(elementClicked.id);
    }

    function getJobTags(job) {
        let allJobTagsElements = job.querySelectorAll('.tag');
        let allJobTagsElementsArray = [].slice.call(allJobTagsElements);

        // console.log(allJobTagsElementsArray.length)

        return allJobTagsElementsArray;
    }

    function getDateRange(job) {
        const possibleDateRanges = ['posted-today', 'posted-over-three-days', 'posted-three-days'];

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

    function requiredTags() {
        let tagsElementsToApply = document.getElementsByClassName('checked-tag');
        let tagsToApplyArray = [].slice.call(tagsElementsToApply);

        return tagsToApplyArray.map(element => element.id);
    }

    function jobMatchesDateFilter(dateFilterSeleted, job) {
        const filtersMapping = {
            // class of filter : class of job
            'posted-today': ['posted-today'],
            'posted-three-days': ['posted-three-days'],
            'show-all-jobs': ['posted-today', 'posted-over-three-days', 'posted-three-days']
        };

        let jobDateRangesThatWouldMatch = filtersMapping[dateFilterSeleted];

        return jobDateRangesThatWouldMatch.includes(job.dateRange)
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
        if (job.dateRangeSelected) {
            if (job.hasFilterTag) {
                if (job.hasMatchingTags) {
                    makeVisible(job)
                } else {
                    makeInvisible(job)
                }
            } else {
                makeVisible(job)
            }
        } else {
            makeInvisible(job)
        }
    }

    function makeVisible(job) {
        if (job.element.classList.contains('default-hidden')) {
            job.element.classList.remove('default-hidden')
        }
        job.element.style.display = "";
        job.elementVisible = true;
    }

    function makeInvisible(job) {
        job.element.style.display = "none";
        job.elementVisible = false;
    }

    function updateJobsFoundCount(visibleJobsCount) {
        document.getElementsByClassName('jobs-count')[0].textContent = visibleJobsCount;
    }

    function decideIfJobHasTagToFilter(job) {
        let possibleTags = Object.values(tagsMapping);

        let matchedTags = 0;

        possibleTags.forEach(function(possibleTag) {
            job.tags.forEach(function(tag) {
                if (tag.classList.contains(possibleTag)) {
                    matchedTags++
                }
            })
        });


        if (matchedTags > 0) {
            job.hasFilterTag = true
        }
    }

    function updateTagsFilters(elementClicked) {
        // toggle the checkbox
        if (elementClicked.classList.contains('checked-tag')) {
            elementClicked.classList.remove('checked-tag')
        } else {
            elementClicked.classList.add('checked-tag')
        }
    }

});
