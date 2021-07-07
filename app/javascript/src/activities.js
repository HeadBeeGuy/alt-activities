// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
let checkboxes;

function activitiesInit() {
    const activityForm = document.querySelector('.activity-form');
    if (!activityForm) return;
    const tagsList = document.querySelector('.activity-form-tag-picker');
    checkboxes = [...tagsList.querySelectorAll('[type="checkbox"]')];
    checkboxes.map(check => {
      check.addEventListener('change', checkTags);
      const e = new Event("change");
      check.dispatchEvent(e);
    });
}

function displayGrammarTagNotice(cat) {
  if (cat.classList.contains("danger-list")) return;
  const html = `<p id="grammar-tags-notice" data-catid=${cat.dataset.catid}>You've selected more than ${cat.dataset.suggestedMax} tags. Please consider limiting your choices to help users searching for activities.</p>`;
  cat.insertAdjacentHTML("beforebegin", html);
  cat.classList.add("danger-list");
}

function removeGrammarTagNotice(cat) {
  if (!cat.classList.contains("danger-list")) return;
  const notice = document.querySelector(`#grammar-tags-notice[data-catid="${cat.dataset.catid}"]`);
  notice.parentNode.removeChild(notice);
  cat.classList.remove("danger-list");
}

function checkTags() {
  const cat = document.querySelector(`.form-tag-list[data-catid="${this.dataset.catid}"]`);
  if (cat.dataset.suggestedMax <= 0) return;
  const catCheckboxes = [...cat.querySelectorAll('[type="checkbox"]')];
  const res = catCheckboxes.reduce((acc, checkbox) => {
    if (checkbox.checked) acc++;
    return acc;
  }, 0);
  return res > parseInt(cat.dataset.suggestedMax) ? displayGrammarTagNotice(cat) : removeGrammarTagNotice(cat);
}

document.addEventListener("turbolinks:load", activitiesInit);
window.addEventListener('pageshow', activitiesInit);
