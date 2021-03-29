// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
let tagsList, checkboxes;

function activitiesInit() {
    const activityForm = document.querySelector('.activity-form');
    if (!activityForm) return;
    tagsList = document.querySelector('[data-catid="3"]');
    checkboxes = [...tagsList.querySelectorAll('[type="checkbox"]')];
    checkboxes.map(check => check.addEventListener('change', checkGrammarTags));
    checkGrammarTags();
}

function displayGrammarTagNotice() {
  if (tagsList.classList.contains("danger-list")) return;
  const html = `<p id="grammar-tags-notice">You've selected more than three grammar tags. Please consider limiting your choices to help users searching for activities.</p>`;
  tagsList.insertAdjacentHTML("beforebegin", html);
  tagsList.classList.add("danger-list");
}

function removeGrammarTagNotice() {
  if (!tagsList.classList.contains("danger-list")) return;
  const notice = document.querySelector("#grammar-tags-notice");
  notice.parentNode.removeChild(notice);
  tagsList.classList.remove("danger-list");
}

function checkGrammarTags() {
  const res = checkboxes.reduce((acc, checkbox) => {
    if (checkbox.checked) acc++;
    return acc;
  }, 0);
  return res > 3 ? displayGrammarTagNotice() : removeGrammarTagNotice();
}

document.addEventListener("turbolinks:load", activitiesInit);
window.addEventListener('pageshow', activitiesInit);
