document.addEventListener("turbolinks:load", function() {
    $(".js-filter").click(function() {
        updateCheckboxes(this);

        let url = "/?";
        url = url + 'filters[date_range]=' + getSelectedDateRange();
        url = url + '&filters[include_jobs_that]=' + encodeURIComponent(JSON.stringify(getFilterTagsToApply()));

        $.ajax({
            url: url,
            success: function(data) {
                // do nothing atm (because it's re-rendering the job listing with the job_listings partial)
            },
            error: function() {
                // do nothing atm (because it's re-rendering the job listing with the job_listings partial)
            }
        });
    });


    const filterImage = document.getElementsByClassName('js-filter-image')[0];
    filterImage.addEventListener('click', toggleFilterForMobile, false)

    /// The question mark symbols next to experience and education with help text
    $(".js-toggle-title-question").click(function() {
        if ($(".js-title-question-text").css("display") == "none") {
            $(".js-title-question-text").show()
        } else {
            $(".js-title-question-text").hide()
        }
    });

    $(".js-toggle-exp-question").click(function() {
        if ($(".js-exp-question-text").css("display") == "none") {
            $(".js-exp-question-text").show()
        } else {
            $(".js-exp-question-text").hide()
        }
    });
    /////////
});

function toggleFilterForMobile() {
    const filterContainer = document.getElementsByClassName('js-filter-container')[0];
    const mobileFilterContainer = document.getElementsByClassName('js-filters-container')[0];

    //  if the filter is not showing then reveal it
    if (mobileFilterContainer.classList.contains('shortened-mobile-filter-container')) {
        filterContainer.classList.remove('hide-filter');
        mobileFilterContainer.classList.remove('shortened-mobile-filter-container');
    } else { // it must be showing so hide it
        filterContainer.classList.add('hide-filter');
        mobileFilterContainer.classList.add('shortened-mobile-filter-container');
    }
}

function updateCheckboxes(checkboxClicked) {
    if (checkboxClicked.classList.contains('js-date-range')) {
        updateDateRangeCheckboxes(checkboxClicked)

    } else if (checkboxClicked.classList.contains('js-filter-tag')) {
        updateFilterTagCheckboxes(checkboxClicked)
    }
}

function updateDateRangeCheckboxes(checkboxClicked) {
    const dateRangeCheckboxes = document.getElementsByClassName('js-date-range-checkbox');
    const dateRangeCheckboxesArray = [].slice.call(dateRangeCheckboxes);


    // uncheck them all
    dateRangeCheckboxesArray.forEach(function(checkbox){
        if (checkbox.classList.contains('checked-date-filter')) {
            checkbox.classList.remove('checked-date-filter');
        }
    });

    // Check the box that was clicked
    checkboxClicked.querySelector('.js-date-range-checkbox').classList.add('checked-date-filter');
}

function updateFilterTagCheckboxes(checkboxClicked) {
    const checkbox = checkboxClicked.querySelector('.js-filter-tag-checkbox');

    // toggle the checkbox
    if (checkbox.classList.contains('checked-tag')) {
        checkbox.classList.remove('checked-tag');
    } else {
        checkbox.classList.add('checked-tag');
    }
}

function getFilterTagsToApply() {
    let tagsElementsToApply = document.getElementsByClassName('checked-tag');
    let tagsToApplyArray = [].slice.call(tagsElementsToApply);

    return tagsToApplyArray.map(element => element.id.replace('filter-tag-', ''));
}

function getSelectedDateRange() {
    const dateFiltersElements = document.getElementsByClassName('js-date-range-checkbox');
    const dateFiltersElementsArray = [].slice.call(dateFiltersElements);

    let dateRangeSelected;

    dateFiltersElementsArray.forEach(function(dateRange) {
        if (dateRange.classList.contains('checked-date-filter')) {
            dateRangeSelected = dateRange.id
        }
    });

    return dateRangeSelected.replace('date-range-', '');
}
