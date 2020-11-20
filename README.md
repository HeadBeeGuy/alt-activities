# ALTopedia


This web app is built to allow English teachers to share activities with each other. It's a relatively standard Ruby on Rails application.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities are submitted by users through a standard web form, but they have to be reviewed by a moderator before they're posted on the live site.

Activities can be assigned a variety of tags to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

The minimum supported browser is IE11. A lot of ALTs have to use old computers that only have IE11 installed. There's probably a minimum threshold at which point we can drop this requirement, but looking at the analytics, it hasn't happened quite yet.

The site now uses Docker in development and production, and (should!) be easy to bring up and running using Docker Compose. The live site just uses the Dockerfile since there isn't any need for the "db" docker image.

---

Higher priority tasks:

- Rework activity approval. Allow trusted users (just about anyone who's contributed to the site) to have a smoother submission and editing experience by letting their contributions be visible immediately.
- Add a longer description field to each Tag for much more information about each. Grammar tags should have example sentences, Japanese terms, and possibly off-site links, a la Englipedia. This should help users get the gist of each grammar point more easily, provide more things for the built-in search to catch, and provide more fodder for search engines. This will be relatively easy to accomplish technically, but will require a lot of time to populate on the live site.

---

Longer-term tasks:

- Get the site working with webhooks to allow integration with Patreon and Discord
- Rebuild the site's interface
- Scan all incoming files for viruses and warn moderators about them
- Look into localizing model data as well (tag data and activity text)
- Parse user-submitted text more thoroughly for HTML or other hinky stuff

---

Lower-priority and smaller tasks:

- Clean up CRUD actions and add tests for Tag Categories
- Change the rendering of Comments (and maybe Activities and Tags) to render by-item so it's easier to use handy Rails shortcuts like "render @comments"

---

Pages to add or revise:

- Improve display of grammar page

---

Current bugs:
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display. Maybe this is fixed in Rails 6 now?
