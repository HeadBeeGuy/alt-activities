# ALTopedia


This web app is built to allow English teachers to share activities with each other. It's a relatively standard Ruby on Rails application.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities are submitted by users through a standard web form, but they have to be reviewed by a moderator before they're posted on the live site.

Activities can be assigned a variety of tags to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

The minimum supported browser is IE11. A lot of ALTs have to use old computers that only have IE11 installed. There's probably a minimum threshold at which point we can drop this requirement, but looking at the analytics, it hasn't happened quite yet.

---

Higher priority tasks:

- Rewrite the site's CSS. This is going to be a big undertaking, but the site is at the stage where we should think about how to build a more consistent and styled interface.
- Upgrade to Rails 6.0
- Let users link different activities together, so they can say that their activity was inspired by another, for example

---

Longer-term tasks:

- Allow users to preview an activity before submission, and let them view their own pending activities
- Dockerize the application since I need to learn how Docker works and it may make it easier to bundle things like anti-virus scanning
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
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display.
