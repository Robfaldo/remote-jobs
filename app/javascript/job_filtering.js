window.addEventListener('DOMContentLoaded', () => {
    const highlightFilter = function (id) {
        let filters = document.getElementsByClassName('filter')

        for (let i = 0; i < filters.length; i++) {
            filters[i].style.backgroundColor = "#4CAF50"
        }

        document.getElementById(id).style.backgroundColor = "#89f58d"
    };

    document.getElementById('posted-today').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');

        for (let i = 0; i < jobs.length; i++) {
            if (jobs[i].classList.contains('posted-today')) {
                jobs[i].style.visibility = "visible";
            } else {
                jobs[i].style.visibility = "hidden";
            }
        }

        document.getElementById('posted-today').style.backgroundColor = "#89f58d"

        highlightFilter('posted-today')
    });

    document.getElementById('posted-three-days').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');

        for (let i = 0; i < jobs.length; i++) {
            if (jobs[i].classList.contains('posted-today') || jobs[i].classList.contains('posted-three-days')) {
                jobs[i].style.visibility = "visible";
            } else {
                jobs[i].style.visibility = "hidden";
            }
        }

        highlightFilter('posted-three-days')
    });

    document.getElementById('show-all-jobs').addEventListener('click', function() {
        let jobs = document.getElementsByClassName('job');

        for (let i = 0; i < jobs.length; i++) {
            jobs[i].style.visibility = "visible";
        }

        highlightFilter('show-all-jobs')
    });
});
