window.addEventListener('DOMContentLoaded', () => {
    let dateRangeCheckBoxes = ['posted-today', 'show-all-jobs', 'posted-three-days'];

    const updateCheckboxes = function() {
        if (isDateRangeFilter(this.id)) {
            // uncheck them all
            for (let i = 0; i < dateRangeCheckBoxes.length; i ++) {
                let checkBox = document.getElementById(dateRangeCheckBoxes[i]);
                if (checkBox.classList.contains('checked-filter')) {
                    checkBox.classList.remove('checked-filter');
                }
            }

            // Check the box that was clicked
            if (!this.classList.contains('checked-filter')) {
                this.classList.add('checked-filter');
            }

            dateFilterToApply = this.id;
        } else { // if its a tag
            // toggle the checkbox
            if (this.classList.contains('checked-tag')) {
                this.classList.remove('checked-tag')
            } else {
                this.classList.add('checked-tag')
            }

        }

        // Get the tags to apply
        let tagsElementsToApply = document.getElementsByClassName('checked-tag');
        let tagsToApplyArray = [].slice.call(tagsElementsToApply);
        let tagsToApply = tagsToApplyArray.map(element => element.id);

        // Get the date filter to apply
        let dateFiltersElements = document.getElementsByClassName('date-filter');
        let dateFiltersElementsArray = [].slice.call(dateFiltersElements);
        let dateFilterToApply = dateFiltersElementsArray.filter(element => element.classList.contains('checked-filter'))[0].id;

        filterJobs(dateFilterToApply, tagsToApply);
    };


    const filterJobs = function(dateFilterToApply, tagsToApply) {
        const filtersMapping = {
            'posted-today': ['posted-today'],
            'posted-three-days': ['posted-three-days'],
            'show-all-jobs': ['posted-today', 'posted-over-three-days', 'posted-three-days']
        };

        const tagsMapping = {
            'requires-experience-filter': 'requires-experience',
            'requires-stem-degree-filter': 'requires-stem-degree'
        };

        let jobs = document.getElementsByClassName('job');
        let visibleElements = 0;

        for (let i = 0; i < jobs.length; i++) {
            const job = jobs[i];

            // change it to jobDateFiltersAllowed and check in the hasRequiredFilter method if at least 1 exxstrs?
            let jobDateFiltersRequired = filtersMapping[dateFilterToApply]; // this means show-all-jobs is always only posted-today

            let jobTagsRequired = [];
            tagsToApply.forEach(tag => jobTagsRequired.push(tagsMapping[tag]));

            if (dateRangeisIncluded(jobDateFiltersRequired, job) && hasRequiredTags(jobTagsRequired, job)) {
                jobs[i].style.display = "";
                visibleElements++;
            } else {
                jobs[i].style.display = "none"
            }

        }

        document.getElementsByClassName('jobs-count')[0].textContent = visibleElements;
    }

    const dateRangeisIncluded = function(datesRangesToInclude, job) {
        let matchedFilters = 0;

        datesRangesToInclude.forEach(function(dateRange) {
            if (job.classList.contains(dateRange)) {
                matchedFilters++
            }
        });

        return matchedFilters > 0
    }

    const hasRequiredTags = function(requiredTags, job) {
        debugger;
        let allJobTagsElements = job.querySelectorAll('.tag');
        let allJobTagsElementsArray = [].slice.call(allJobTagsElements);

        let matchedTags = [];

        requiredTags.forEach(function(tag) {
            allJobTagsElementsArray.forEach(function(el) {
                if (el.classList.contains(tag)) {
                    matchedTags.push(el);
                }
            })
        });

        return matchedTags.length == requiredTags.length
    }

    const isDateRangeFilter = function(id) {
        return dateRangeCheckBoxes.includes(id);
    };

    let checkBoxes = document.getElementsByClassName('filter-box');

    for (let i = 0; i < checkBoxes.length; i++) {
        checkBoxes[i].addEventListener('click', updateCheckboxes, false);
    }
});
