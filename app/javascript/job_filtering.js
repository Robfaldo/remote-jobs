window.toggleCheckbox = function(element, checkboxId) {
    // toggle checkbox
    checkbox = document.getElementById(checkboxId)
    checkbox.checked = checkbox.checked ? false : true;


    // toggle button
    if (element.classList.contains("button-unselected")) {
        element.classList.remove("button-unselected");
        element.classList.add("button-selected");
    } else if (element.classList.contains("button-selected")) {
        element.classList.remove("button-selected");
        element.classList.add("button-unselected");
    }
}
