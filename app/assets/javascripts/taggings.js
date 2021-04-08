// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
let tags;

function taggingsInit() {
    tags = [...document.querySelectorAll('.activity-tags-list li')];
    if (!tags.length) return;

    //select2 initialization only works with a jQuery call
    const select = document.querySelector('#edit-tag-search-select');

    if (select) {
        // console.log('found select');
        $('select#edit-tag-search-select').select2({
            placeholder: 'Select a tag and press submit to add it',
            width: '90%'
        });
    }

    disableSelectedTags();
}

function disableSelectedTags() {
    tags.map( tag => {
        const option = document.querySelector(`option[value="${tag.dataset.id}"]`);
        option.disabled = true;
        if (option.selected) option.selected = false;
    })
}

document.addEventListener("turbolinks:load", taggingsInit);
window.addEventListener('pageshow', taggingsInit);