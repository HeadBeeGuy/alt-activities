# ALTopedia


This web app is built to allow English teachers to share activities with each other. It's a relatively standard Ruby on Rails application.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities can be assigned a variety of **Tags** to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

The minimum supported browser is IE11. A lot of ALTs have to use old computers that only have IE11 installed. Some elements in the periphery (ActiveStorage?) seem to be breaking already, but the site needs to be visible, at least, in IE11.

The site uses Docker in development and production. The easiest way to run it in development is to clone the repo, run `docker-compose build` to build everything, `docker-compose up` to start up the db and web server, then `docker-compose run web bundle exec rails db:setup` to create and seed the initial database. You can feed it commands like a normal Rails app by passing commands to the container using docker-compose. For example, `docker-compose run web bundle exec rails test` will run the test suite.

Once everything is working, the web server and db containers can be started up with `docker-compose up` and shut down with `docker-compose down`. The development environment is seeded with example data. Every account in the development enviroment has the password "badpassword". The administrator is named "Local Admin".

---

Higher priority tasks:

- Add a longer description field to each Tag for much more information about each. Grammar tags should have example sentences, Japanese terms, and possibly off-site links, a la Englipedia. This should help users get the gist of each grammar point more easily, provide more things for the built-in search to catch, and provide more fodder for search engines. This will be relatively easy to accomplish technically, but will require a lot of time to populate on the live site.
- Add a description field for Tag Categories to guide people on how to choose them when submitting an activity. For example, there probably shouldn't be more than 3 grammar point tags for a given activity.
- Set a flag for users that are paid contributors. They'll get the best of the new features as they're developed. Hopefully this will be a viable alternative to running advertisements. At first, this could be a manual flag, but it should be automated if it becomes necessary.

---

Longer-term tasks:

- Get the site working with webhooks to allow integration with Patreon and Discord
- Rebuild the site's interface - primarily in Flexbox, since IE11's support for CSS Grid requires adding a bunch of annoying extra code
- Scan all incoming files for viruses and warn moderators about them
- Look into localizing model data as well (tag data and activity text)
- Parse user-submitted text more thoroughly for HTML or other hinky stuff
- Allow activities to link to specific textbook pages
- Add a field to Tag Categories to control whether they're displayed collapsed by default on the Activity form page
- Add more user profile information, and allow users to say more about themselves if they're so inclined. 
- Switch permission management from Pundit to Cancancan. This will make the code in the controllers simpler since Cancancan allows standard controller methods to automatically load data for the current user given their permission level. This will likely involve rewriting a lot of integration tests since permission errors raise an exception instead of quietly failing.
- See if the fancy new text editor in Rails 6 can be used with Markdown, since that's how Activities and FrontPagePosts are formatted.

---

Lower-priority and smaller tasks:

- Clean up CRUD actions and add tests for Tag Categories
- Change the rendering of Comments (and maybe Activities and Tags) to render by-item so it's easier to use handy Rails shortcuts like "render @comments"
- Potentially remove the "Solved" status for Comments, since that doesn't seem to have been very useful and it complicates comment code. Maybe it would be better replaced by a "visible" boolean value instead.

---

Pages to add or revise:

- Improve display of grammar page
- Add a section for what to do during downtime at school - Japanese study, online study programs, programming tutorials, and so on.

---

Current bugs:
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display. Maybe this is fixed in Rails 6 now?

---

These pages must be restyled or rebuilt before the site should go live:

- The Mod Queue
- The Contributors page

These would be nice to get working:

- Comments index page
- Tag form
- Grammar Points page
- Activity Themes page
- Tag Index page
- All Tag Category pages
- Activity index page
- Activity Link pages
