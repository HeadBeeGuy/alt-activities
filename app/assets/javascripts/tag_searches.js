// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

let tagAcc, selectValues;

function init() {
  const form = document.querySelector('#tag-search-form'); //tag searches container
  tagAcc = document.querySelector('#tag-accumulator');
  if (!form) return;
  const tags = [...document.querySelectorAll('.form-tag-checkbox')];

  tags.map(tag => {if (tag.checked) append(tagAcc, tag.value, tag.dataset.text)});
  tags.map(tag => tag.addEventListener('change', handleTagClick));
}

const append = (ref, val, text) => {
  const curEl = tagAcc.querySelector(`[data-value='${val}']`);
  if (curEl) return;
  
  //Add an li element to the list in the category header
  const html = `
    <li onclick="handleTagAccClick(this)" data-value="${val}" data-text="${text}">
      <span>${text}</span>
    </li>
  `
  ref.insertAdjacentHTML('afterbegin', html);
};

const remove = (ref, value, update) => {
  const curEl = tagAcc.querySelector(`[data-value='${value}']`);
  if (!curEl) return;

  const child = [...ref.children].find(child => child.dataset.value === value);
  ref.removeChild(child);
}

const handleTagClick = function () {
  if (this.checked) {
    append(tagAcc, this.value, this.dataset.text);
    const option = document.querySelector(`option[value="${this.value}"]`);
    option.selected = true;
    sendEventToSelect();
  } else {
    remove(tagAcc, this.value);
    const option = document.querySelector(`option[value="${this.value}"]`);
    option.selected = false;
    sendEventToSelect();
  }
};

const handleTagAccClick = (item) => {
  remove(tagAcc, item.dataset.value);
  const tag = document.querySelector(`input[value='${item.dataset.value}']`);
  const option = document.querySelector(`option[value='${item.dataset.value}']`);
  tag.checked = false;
  option.selected = false;
  sendEventToSelect();
}

handleSelect = (e) => {
  console.log(e.params.data);
  append(tagAcc, e.params.data.id, e.params.data.text);
  const tag = document.querySelector(`input[value="${e.params.data.id}"]`);
  tag.checked = true;
}

handleUnselect = (e) => {
  console.log(e.params.data);
  remove(tagAcc, e.params.data.id);
  const tag = document.querySelector(`input[value="${e.params.data.id}"]`);
  tag.checked = false;
}

const sendEventToSelect = () => {
  const e = new Event("change");
  const select = document.querySelector('#tag-search-select');
  select.dispatchEvent(e);
}

document.addEventListener("turbolinks:load", init);
window.addEventListener('pageshow', init);

$(document).ready(function() {
  //select2 initialization only works with a jQuery call
  $('select#tag-search-select').select2({
    placeholder: 'Text search for all tags',
    width: '90%'
  });

  $('select#tag-search-select').on('select2:select', handleSelect);
  $('select#tag-search-select').on('select2:unselect', handleUnselect);
})

