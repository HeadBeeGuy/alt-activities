# ALTopedia


This web app is built to allow English teachers to share activities with each other.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities are submitted by users through a standard web form, but they have to be reviewed by a moderator before they're posted on the live site.

Activities can be assigned a variety of tags to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

---

Higher priority tasks:

- Activity search system using AND search system with tags
- Redirect users to their profiles upon account activation and possibly login
- Add "Sign up/Register" to the top navbar when viewing the page when logged out - currently it's a little hard to find

---

Longer-term tasks:

- Dockerize the application since I need to learn how Docker works and it may make it easier to bundle things like anti-virus scanning
- Take a deeper look at how taggings are generated during activity creation. I didn't whitelist the parameter as an array correctly, but when I do that, activity creation breaks. This also causes problems when the server is processing file uploads for ActiveStorage and locks the database.
- Scan all incoming files for viruses and warn moderators about them
- OAuth integration - or maybe not, if the big OAuth providers keep behaving badly!
- System for users to submit ideas for new tags or textbooks
- Look into localizing model data as well (tag data and activity text)
- Parse user-submitted text more thoroughly for HTML or other hinky stuff
- Add a captcha to user registration and possibly activity submission for accounts that don't have any approved activities
- Restrict the file types and file size of uploaded files. Maybe Rails 6.0 will build in some kind of validations?
- Rewrite site CSS to get away from Bootstrap - its Flexbox classes have been frustrating to work with, and I feel like we'll eventually outgrow its limits. It's possible to heavily customize Bootstrap, but this may be more work in the end than just building the site's CSS from scratch.
- Allow users to publicly display activities that they've upvoted. Maybe this will be opt-in since I can see some users may not want all and sundry to see what they liked.

---

Lower-priority and smaller tasks:

- Clean up CRUD actions and add tests for Tag Categories
- Change the rendering of Comments (and maybe Activities and Tags) to render by-item so it's easier to use handy Rails shortcuts like "render @comments"
- Construct a more robust database seed for the development environment

---

Pages to add or revise:

- Improve display of grammar page
- See if a general "Contribute" section leads to more people submitting activities or offering to help with localization
- Improve display of textbook page

---

Current bugs:
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display.
