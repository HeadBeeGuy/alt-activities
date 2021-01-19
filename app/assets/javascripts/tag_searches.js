// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("turbolinks:load", function() {
  //Initialize tooltips, taken from the vanilla Bootstrap docs
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  });
})

$(window).on("pageshow", function () {

  const checkboxes = [].slice.call(document.querySelectorAll('input.form-check-input'));

  if (checkboxes.length) {
    checkboxes.map(checkbox => {
      if (checkbox.checked) {
        const num = checkbox.parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-')[2];
        const ref = document.getElementById(`selected_items-${num}`);
        const text = checkbox.parentNode.innerText;

        checkbox.parentNode.classList.contains('btn-active') ? null : toggleAlertBorder(checkbox);

        append(ref, text);
      }
    })
  }
})

const append =  (ref, text) => {
  //Add an li element to the list in the category header

  const node = document.createElement("LI");
  const textnode = document.createTextNode(text);
      
  node.appendChild(textnode);

  ref.appendChild(node);
}

const getChildNodeIndex = function(children, text) {
  const arr = Array.from(children);

  const index = arr.findIndex(li => {
    return li.innerText === text;
  })

  return index;
}

const handleTagClick = function(e) {

    const checked = e.checked;
    const num = e.parentNode.parentNode.parentNode.parentNode.parentNode.id.split('-')[2];
    const ref = document.getElementById(`selected_items-${num}`);
    const text = e.parentNode.innerText;
    
    if (checked) {
      append(ref, text);
    } else {

      const ind = getChildNodeIndex(ref.children, text);

      ref.removeChild(ref.childNodes[ind]);
    }

    toggleAlertBorder(e)
    
}

const toggleAlertBorder = function(e) {
  e.parentNode.classList.toggle('btn-active');
  e.parentNode.classList.toggle('btn-success');
}