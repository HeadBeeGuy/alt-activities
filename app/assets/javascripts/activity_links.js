// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function activityLinksInit() {
    //select2 initialization only works with a jQuery call
    const select = document.querySelector('#activity_link_id');

    if (!select) return;

    if (select && !select.classList.contains('select2-hidden-accessible')) {
        $('select#activity_link_id').select2({
            placeholder: 'Search for an activity and press link to add it',
            width: '90%',
            ajax: {
                url: '/activities',
                dataType: 'json',
                delay: 300,
                data: function (params) {
                    return {term: params.term}
                },
                processResults: (data) => {
                    return {
                        results: data
                    };
                }
            },
            minimumInputLength: 2,
            templateResult: (item) => item.name,
            templateSelection: (item) => item.name
        });
    }
}


document.addEventListener("turbolinks:load", activityLinksInit);
window.addEventListener('pageshow', activityLinksInit);
