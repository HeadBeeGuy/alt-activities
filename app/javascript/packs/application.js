/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

//These are for polyfills. See docs here: https://babeljs.io/docs/en/babel-polyfill

import "core-js/stable";
import "regenerator-runtime/runtime";
import "whatwg-fetch"; //https://github.com/github/fetch
import "promise-polyfill/src/polyfill"; //https://github.com/taylorhakes/promise-polyfill

//Import your code
import '../src/activities';
import '../src/activity_links';
import '../src/tag_searches';
import '../src/taggings';


