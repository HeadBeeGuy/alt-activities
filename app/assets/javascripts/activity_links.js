// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

let linkBut;

function activityLinksInit() {
    //select2 initialization only works with a jQuery call
    const select = document.querySelector('#activity_link_id');

    if (!select) return;

    if (select && !select.classList.contains('select2-hidden-accessible')) {
        $('select#activity_link_id').select2({
            placeholder: "Search for an activity and press link to add it",
            allowClear: true,
            width: '90%',
            ajax: {
                url: '/activity_links/link_search',
                dataType: 'json',
                delay: 300,
                data: function (params) {
                    return {
                        term: params.term,
                        inspired_id: parseInt(document.querySelector('#inspired_id').value)
                    }
                },
                processResults: (data) => {
                    return {
                        results: data
                    };
                }
            },
            minimumInputLength: 2,
            templateResult: (item) => {
                if (item.name) return `${item.name} - ${item.description} (${item.author})`
            },
            templateSelection: (item) => {
                if (item.name) return `${item.name} - ${item.description} (${item.author})`
            }
        });
        $('select#activity_link_id').on('select2:select', handleLinkSelect);
        $('select#activity_link_id').on('select2:unselect', handleLinkUnselect);
    }
    linkBut = document.querySelector('input[value="Link"]');
}

handleLinkSelect = () => {
    if (linkBut.disabled) {
        return linkBut.disabled = false; 
    }
}

handleLinkUnselect = () => {
    if (!linkBut.disabled) {
        return linkBut.disabled = true; 
    }
}


document.addEventListener("turbolinks:load", activityLinksInit);
window.addEventListener('pageshow', activityLinksInit);
