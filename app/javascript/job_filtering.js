// import {updateJobs} from "./update_jobs";
//
// document.addEventListener("turbolinks:load", function() {
//     console.log('turbolinks load')
// });
//
// window.addEventListener('DOMContentLoaded', () => {
//     console.log('page load')
//     // Everything in here will be executed on page load!
//
//     const dateRangeCheckboxes = document.getElementsByClassName('js-date-range-checkbox');
//     const dateRangeCheckboxesArray = [].slice.call(dateRangeCheckboxes);
//
//     const tagCheckboxes =  document.getElementsByClassName('js-experience-tag-checkbox');
//     const tagCheckboxesArray = [].slice.call(tagCheckboxes);
//
//     const filterContainerMobile = document.querySelector('.filters-container-mobile');
//
//     // I'm having to put this in if conditional because I need to share this javascript file with the view jobs page (and it would break here if not)- should refactor this at some point.
//     if (filterContainerMobile) {
//         const filterImage = filterContainerMobile.getElementsByClassName('js-filter-image')[0];
//         filterImage.addEventListener('click', toggleFilterForMobile, false)
//     }
//
//     // Add event Listeners
//     dateRangeCheckboxesArray.forEach(function(checkbox){
//         checkbox.addEventListener('click', updateDateRange, false)
//     });
//
//     tagCheckboxesArray.forEach(function(checkbox){
//         checkbox.addEventListener('click', updateTag, false)
//     });
//
//
//     // Run this so that it hides the jobs that require experience/degrees etc.. and updates the job count on initial page load
//     updateJobs();
//
//     function updateDateRange() {
//         updateDateRangeFilters(this, dateRangeCheckboxesArray);
//         updateJobs();
//     }
//
//     function updateTag() {
//         updateDateTag(this);
//         updateJobs();
//     }
// });
//
// function toggleFilterForMobile() {
//     const filterContainer = document.querySelector('.filters-container-mobile').getElementsByClassName('js-filter-container')[0];
//     const mobileFilterContainer = document.getElementsByClassName('js-mobile-filters-container')[0];
//
//     //  if the filter is not showing then reveal it
//     if (mobileFilterContainer.classList.contains('shortened-mobile-filter-container')) {
//         filterContainer.classList.remove('hide-filter');
//         mobileFilterContainer.classList.remove('shortened-mobile-filter-container');
//     } else { // it must be showing so hide it
//         filterContainer.classList.add('hide-filter');
//         mobileFilterContainer.classList.add('shortened-mobile-filter-container');
//     }
// }
//
// function updateDateRange() {
//     updateDateRangeFilters(this, dateRangeCheckboxesArray);
//     updateJobs();
// }
//
// function updateTag() {
//     updateDateTag(this);
//     updateJobs();
// }
//
// function updateDateRangeFilters(dateFilterClicked, dateRangeCheckboxesArray) {
//     // uncheck them all
//     dateRangeCheckboxesArray.forEach(function(checkbox){
//         if (checkbox.classList.contains('checked-date-filter')) {
//             checkbox.classList.remove('checked-date-filter');
//         }
//     });
//
//     // Check the box that was clicked
//     dateFilterClicked.classList.add('checked-date-filter');
// }
//
// function updateDateTag(tagClicked) {
//     // toggle the checkbox
//     if (tagClicked.classList.contains('checked-tag')) {
//         tagClicked.classList.remove('checked-tag');
//     } else {
//         tagClicked.classList.add('checked-tag');
//     }
// }
