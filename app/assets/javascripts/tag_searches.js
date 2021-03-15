// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

let tagsList, newActivity;

function init() {
  const form = document.querySelector('#tag-search-form'); //tag searches container
  newActivity = document.querySelector('#new_activity');
  const tagChooser = document.querySelector('.tag-chooser');
  tagsList = document.querySelector('#selected_items-3');

  if (!form && !tagChooser) return;

  //tooltips
  setTooltips();
  //checkboxes
  setCheckboxes();
  //see if there are more than three grammar tags selected
  if (newActivity) checkGrammarTags();
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

  // console.log(checkboxes.length);

  if (checkboxes.length) {
    checkboxes.map((checkbox) => {
      // console.log(checkbox.checked);

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

      checkbox.addEventListener("change", handleTagClick);
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

  //see if more than three grammar tags are selected
  if (newActivity) checkGrammarTags();
};

const toggleAlertBorder = function (e) {
  e.parentNode.classList.toggle("btn-active");
  e.parentNode.classList.toggle("btn-success");
};

function displayGrammarTagNotice() {
  if (tagsList.classList.contains('danger-list')) return;
  const html = `<p id="grammar-tags-notice">You've selected more than three grammar tags. Please consider limiting your choices to help users searching for activities.</p>`
  tagsList.insertAdjacentHTML('beforebegin', html);
  tagsList.classList.add('danger-list');
}

function removeGrammarTagNotice() {
  if (!tagsList.classList.contains('danger-list')) return;
  const notice = document.querySelector('#grammar-tags-notice');
  notice.parentNode.removeChild(notice);
  tagsList.classList.remove('danger-list');
}

function checkGrammarTags() {
  checkboxes = [...document.querySelectorAll('[data-id="3"]')];
  const res = checkboxes.reduce((acc, checkbox) => {
    if (checkbox.checked) acc++
    return acc;
  }, 0);
  return res > 3 ? displayGrammarTagNotice() : removeGrammarTagNotice();
}

document.addEventListener("turbolinks:load", init);
window.addEventListener('pageshow', init);

