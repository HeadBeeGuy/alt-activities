// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function init() {
  //tooltips
  setTooltips();
  //checkboxes
  setCheckboxes();
}

function setTooltips() {
  //Initialize tooltips, taken from the vanilla Bootstrap docs
  const tooltipTriggerList = [
    ...document.querySelectorAll('[data-bs-toggle="tooltip"]'),
  ];
  tooltipTriggerList.map(function (el) {
    return new bootstrap.Tooltip(el);
  });
}

function setCheckboxes() {
  const checkboxes = [...document.querySelectorAll("input.form-check-input")];

  console.log(checkboxes.length);

  if (checkboxes.length) {
    checkboxes.map((checkbox) => {
      console.log(checkbox.checked);

      if (checkbox.checked) {
        const num = checkbox.dataset.id;
        const ref = document.getElementById(`selected_items-${num}`);
        const text = checkbox.dataset.text;
        const curItems =
          [...ref.childNodes].map((child) => child.innerText) || [];

        //on page load, if the checkbox is checked from a previous page instance then toggle the active class
        checkbox.parentNode.classList.contains("btn-active")
          ? null
          : toggleAlertBorder(checkbox);

        //Check to see if the list includes the text node before adding it to solve issues of duplicates on Firefox
        curItems.includes(text) ? null : append(ref, text);
      }

      checkbox.addEventListener("click", handleTagClick);
    });
  }
}

const append = (ref, text) => {
  //Add an li element to the list in the category header

  const node = document.createElement("LI");
  const textnode = document.createTextNode(text);

  node.appendChild(textnode);

  ref.appendChild(node);
};

const getChildNodeIndex = function (children, text) {
  const arr = Array.from(children);

  const index = arr.findIndex((li) => {
    return li.innerText === text;
  });

  return index;
};

const handleTagClick = function () {
  const checked = this.checked;
  const num = this.dataset.id;
  const ref = document.getElementById(`selected_items-${num}`);
  const text = this.dataset.text;

  if (checked) {
    append(ref, text);
  } else {
    const ind = getChildNodeIndex(ref.children, text);
    ref.removeChild(ref.childNodes[ind]);
  }
  //toggle the border
  toggleAlertBorder(this);
};

const toggleAlertBorder = function (e) {
  e.parentNode.classList.toggle("btn-active");
  e.parentNode.classList.toggle("btn-success");
};

$(document).on("turbolinks:load", init);
window.addEventListener('pageshow', setCheckboxes);
