document.addEventListener("turbolinks:load", function() {
    $(".js-filter").click(function() {
        updateCheckboxes(this);

        let url = "/?";
        url = url + 'filters[date_range]=' + getSelectedDateRange();
        url = url + '&filters[include_jobs_that]=' + encodeURIComponent(JSON.stringify(getFilterTagsToApply()));
        window.location = url;
    });
});

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
