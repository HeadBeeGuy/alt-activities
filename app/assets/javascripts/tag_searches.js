// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

let tagAcc;

function init() {
  const form = document.querySelector('#tag-search-form'); //tag searches container
  tagAcc = document.querySelector('#tag-accumulator');
  if (!form) return;
  const tags = [...document.querySelectorAll('.form-tag-checkbox')];

  tags.map(tag => {if (tag.checked) append(tagAcc, tag)});
  tags.map(tag => tag.addEventListener('change', handleTagClick));
}

const append = (ref, item) => {
  //Add an li element to the list in the category header
  const html = `
    <li onclick="handleTagAccClick(this)" data-value="${item.value}" data-text="${item.dataset.text}">
      <p>${item.dataset.text}</p>
    </li>
  `
  ref.insertAdjacentHTML('afterbegin', html);
};

const remove = (ref, value) => {
  const child = [...ref.children].find(child => child.dataset.value === value);
  ref.removeChild(child);
}

const handleTagClick = function () {
  if (this.checked) {
    append(tagAcc, this);
  } else {
    remove(tagAcc, this.value);
  }
};

const handleTagAccClick = (item) => {
  remove(tagAcc, item.dataset.value);
  const tag = document.querySelector(`[value='${item.dataset.value}']`);
  tag.checked = false;
}

document.addEventListener("turbolinks:load", init);
window.addEventListener('pageshow', init);

