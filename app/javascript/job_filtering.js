window.addEventListener('DOMContentLoaded', () => {
    const selectFilter = function (id, visible_jobs_count) {
        let filters = document.getElementsByClassName('filter-box');

        for (let i = 0; i < filters.length; i++) {
            filters[i].style.backgroundColor = "#ffffff";
        };

        document.getElementById(id).style.backgroundColor = "#3cbfab";
        document.getElementsByClassName('jobs-count')[0].textContent = visible_jobs_count;
    };

    document.getElementById('posted-today').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');
        let visible_jobs_count = 0;

        for (let i = 0; i < jobs.length; i++) {
            if (jobs[i].classList.contains('posted-today')) {
                jobs[i].style.visibility = "visible";
                visible_jobs_count++
            } else {
                jobs[i].style.visibility = "hidden";
            };
        };

        document.getElementById('posted-today').style.backgroundColor = "#89f58d";

        selectFilter('posted-today', visible_jobs_count);
    });

    document.getElementById('posted-three-days').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');
        let visible_jobs_count = 0;

        for (let i = 0; i < jobs.length; i++) {
            if (jobs[i].classList.contains('posted-today') || jobs[i].classList.contains('posted-three-days')) {
                jobs[i].style.visibility = "visible";
                visible_jobs_count++
            } else {
                jobs[i].style.visibility = "hidden";
            };
        };

        selectFilter('posted-three-days', visible_jobs_count);
    });

    document.getElementById('show-all-jobs').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');
        let visible_jobs_count = 0;

        for (let i = 0; i < jobs.length; i++) {
            jobs[i].style.visibility = "visible";
            visible_jobs_count++;
        };

        selectFilter('show-all-jobs', visible_jobs_count);
    });
});
