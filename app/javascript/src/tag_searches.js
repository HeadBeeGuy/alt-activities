// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// A polyfill for custom events on IE
(function () {

  if ( typeof window.CustomEvent === "function" ) return false;

  function CustomEvent ( event, params ) {
    params = params || { bubbles: false, cancelable: false, detail: null };
    var evt = document.createEvent( 'CustomEvent' );
    evt.initCustomEvent( event, params.bubbles, params.cancelable, params.detail );
    return evt;
   }

  window.CustomEvent = CustomEvent;
})();

let tagAcc, tagChecks, form, newActivityForm, paginationPage = 1, pages, list, paginationCon, sort = 'created_at', narrowTagsCon, sortingButtonsCon;

function init() {
  //select2 initialization only works with a jQuery call
  const select = document.querySelector('#tag-search-select');

  if (select && !select.classList.contains('select2-hidden-accessible')) {
    $('select#tag-search-select').select2({
      placeholder: 'Text search for all tags',
      width: '90%'
    });
  
    $('select#tag-search-select').on('select2:select', handleSelect);
    $('select#tag-search-select').on('select2:unselect', handleUnselect);
  }

  form = document.querySelector('#tag-search-form'); //tag searches container
  newActivityForm = document.querySelector('.activity-form'); //new activity form
  list = document.querySelector(".activity-card-list"); //query results go here
  paginationCon = document.querySelector('.pagination-buttons'); //pagination buttons container
  narrowTagsCon = document.querySelector('.narrow-tags');
  sortingButtonsCon = document.querySelector('.sorting-buttons');
  if (!form && !newActivityForm) return;
  tagAcc = document.querySelector('#tag-accumulator');
  tagChecks = [...document.querySelectorAll('.form-tag-checkbox')];
  tagChecks.map(tag => {if (tag.checked) append(tagAcc, tag.value, tag.dataset.text)});
  if (tagChecks.some(tag => tag.checked)) sendEventToSelect();
  tagChecks.map(tag => tag.addEventListener('change', handleTagClick));
}

const append = (ref, val, text) => {
  if (!tagAcc) return;
  const curEl = tagAcc.querySelector(`[data-value='${val}']`);
  if (curEl) return;
  
  //Add an li element to the list in the category header
  const html = `
    <li data-value="${val}" data-text="${text}">
      <span>${text}</span>
    </li>
  `
  ref.insertAdjacentHTML('afterbegin', html);

  const li = document.querySelector(`li[data-value="${val}"]`);
  li.addEventListener('click', handleTagAccClick);
};

const remove = (ref, value) => {
  if (!tagAcc) return;
  const curEl = tagAcc.querySelector(`[data-value='${value}']`);
  if (!curEl) return;

  const child = [...ref.children].find(child => child.dataset.value === value);
  ref.removeChild(child);
}

const handleTagClick = function () {
  if (this.checked) {
    append(tagAcc, this.value, this.dataset.text);
    const option = document.querySelector(`option[value="${this.value}"]`);
    form ? option.selected = true : option.disabled = true;
    sendEventToSelect();
    query();
  } else {
    remove(tagAcc, this.value);
    const option = document.querySelector(`option[value="${this.value}"]`);
    form ? option.selected = false : option.disabled = false;
    sendEventToSelect();
    query();
  }
};

function handleTagAccClick() {
  // console.log(this);
  remove(tagAcc, this.dataset.value);
  const tag = document.querySelector(`input[value='${this.dataset.value}']`);
  const option = document.querySelector(`option[value='${this.dataset.value}']`);
  tag.checked = false;
  option.selected = false;
  sendEventToSelect();
  query();
}

const handleSelect = (e) => {
  // console.log(e.params.data);
  append(tagAcc, e.params.data.id, e.params.data.text);
  const tag = document.querySelector(`input[value="${e.params.data.id}"]`);
  if (form) tag.checked = true
  if (newActivityForm) tag.disabled = true;
  query();
}

const handleUnselect = (e) => {
  // console.log(e.params.data);
  remove(tagAcc, e.params.data.id);
  const tag = document.querySelector(`input[value="${e.params.data.id}"]`);
  if (form) tag.checked = false
  if (newActivityForm) tag.disabled = false;
  query();
}

const sendEventToSelect = () => {
  const e = new CustomEvent("change");
  const select = document.querySelector('#tag-search-select');
  select.dispatchEvent(e);
}

function handleSort() {
  sort = this.dataset.sort;
  return query();
}

const query = () => {

  let q = tagChecks.reduce((acc, tag) => {
    if (!tag.checked) return acc;

    acc.push(`tag_ids[]=${tag.value}`);
    return acc;
  }, []).join('&');

  if (!q) return displayWelcomeMessage();

  q += `&order=${sort}`
  paginationPage = 1;

  const url = `/tag_search?${q}`;
  // console.log(url);
  window.fetch(url)
  .then(res => {
    // console.log(res);
    if (res.ok) {
      return res.json();
    }
  })
  .then(res => paginate(res))
  .catch(err => displayError(err));
}

const displayError = (err) => {
  list.innerHTML = `
    <p>
      An error occurred! ${err}
    </p>
  `

  return resetPage();
}

function displayWelcomeMessage() {
  list.innerHTML = `
    <p>
      Select a tag to get started finding your next great activity!
    </p>
  `
  return resetPage();
}

function displayNoResultsMessage() {
  list.innerHTML = `
    <p class="warning">
      No activities were found matching those tags.
    </p>
  `
  scrollToResultsTop();
  return resetPage();
}

const resetPage = () => {
  paginationCon.innerHTML = '';
  narrowTagsCon.innerHTML = '';
  sortingButtonsCon.innerHTML = '';
  const text = [...document.querySelectorAll(".hide-title")];
  text.map(title => title.classList.add('hide'));
}

const paginate = (res) => {
  // console.log(res);
  if (!res || !res.length) return displayNoResultsMessage();
  const itemsPerPage = 10;
  let curPage = 0;
  pages = res.reduce((acc, activity) => {
    if (!acc[curPage] || acc[curPage].length >= itemsPerPage) {
      curPage += 1;
      acc[curPage] = [];
    }
    acc[curPage].push(activity);
    return acc;
  }, {});

  displayResults(pages);
  buildPageButtons(Object.keys(pages).length);
  buildSortingButtons(pages[1][0]);
  buildTagNarrowButtons(res);
}

const buildSortingButtons = activity => {
  let html = ``;
  const skipArr = [
    'short_description',
    'id',
    'taggings'
  ]

  const renames = {
    created_at: 'Recently created',
    updated_at: 'Recently updated',
    name: 'Activity name',
    time_estimate: 'Length',
    upvote_count: 'Likes'
  }

  if (activity) {
    Object.keys(activity).map(key => {
      if (skipArr.includes(key)) return;
      const finKey = key !== 'upvote_count' ? key : 'upvote_count DESC';
      const button = `
        <button data-sort='${finKey}' class=${sort === finKey ? 'active-sort' : null}>
          ${renames[key]}
        </button>
      `
      html += button;
    })
  }
  
  sortingButtonsCon.innerHTML = html;

  const sorts = [...document.querySelectorAll('button[data-sort]')];
  if (sorts) sorts.map(but => but.addEventListener('click', handleSort));
}

const buildTagNarrowButtons = activities => {
  let html = '';
  
  if (activities.length > 1) {
    const checkedTags = tagChecks.reduce((acc, tag) => {
      if (tag.checked) acc.push(parseInt(tag.value));
      return acc;
    }, []);
  
    // console.log(checkedTags);
  
    const tagsToButtons = activities.reduce((acc, activity) => {
      activity.taggings.map( tagging => {
        // console.log(tagging.tag_id, checkedTags);
        if (checkedTags.includes(tagging.tag_id) || acc.includes(tagging.tag_id)) return;

        acc.push(tagging.tag_id);
      });
      return acc;
    }, []);

    tagsToButtons.map(tag => {
      const tagCheck = document.querySelector(`input[value="${tag}"]`)
  
      // console.log(tagCheck);
  
      const tagBut = `
        <button class="narrow-tag" data-tagid="${tag}">
          ${tagCheck.dataset.text}
        </button>
      `
  
      html += tagBut;
    })
    
  }

  narrowTagsCon.innerHTML = html;
  const buts = [...document.querySelectorAll(".narrow-tag")];
  if (buts) buts.map(but => but.addEventListener('click', handleNarrowTagClick));
}

function handleNarrowTagClick() {
  // console.log(this.dataset.tagid);

  const tagCheck = document.querySelector(`input[value="${this.dataset.tagid}"]`);
  tagCheck.click();
  query();
  scrollToResultsTop();
}

const buildPageButtons = (num) => {
  if (num <= 0) return;
  let html = '';
  let n = 1;
  do {
    const button = `
      <button data-page=${n} class=${n === 1 ? "active" : null}>
        ${n}
      </button>
    `

    html += button;
    n++;
  } while (n <= num)

  paginationCon.innerHTML = html;

  const buts = [...document.querySelectorAll('button[data-page]')];
  if (buts) buts.map(but => but.addEventListener('click', handlePageButtonClick));
}

function handlePageButtonClick() {
  const curPageButton = document.querySelector(`button[data-page="${paginationPage}"]`);
  if (curPageButton) curPageButton.classList.remove('active');
  this.classList.add('active');
  paginationPage = this.dataset.page;
  displayResults(pages);
  scrollToResultsTop();
}

function scrollToResultsTop() {
  const h = document.querySelector('.tag-search-results')
  window.scrollTo(0, h.offsetTop - 5);
}

const displayResults = (pages) => {

  let html = '';
  
  pages[paginationPage].map(activity => {
    const activityLinkName = activity.name.replace(" ", "-").toLowerCase();

    return html += `
    <li class="activity-card" title="${activity.short_description}">
      <a href="/activities/${activity.id}-${activityLinkName}">
        <p class="activity-card-name">${activity.name}</p>
        <p class="activity-card-description">${activity.short_description}</p>
      </a>
    </li>
  `
  })

  const text = [...document.querySelectorAll(".hide-title")];
  text.map(title => title.classList.remove('hide'));

  list.innerHTML = '';
  list.innerHTML = html;
}

document.addEventListener("turbolinks:load", init);
window.addEventListener('pageshow', init);

