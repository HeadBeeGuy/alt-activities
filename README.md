# ALTopedia


This web app is built to allow English teachers to share activities with each other. It's a relatively standard Ruby on Rails application.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities can be assigned a variety of **Tags** to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

The minimum supported browser is IE11. A lot of ALTs have to use old computers that only have IE11 installed. Some elements in the periphery (ActiveStorage?) seem to be breaking already, but the site needs to be visible, at least, in IE11.

The site uses Docker in development and production. The easiest way to run it in development is to clone the repo, run `docker-compose build` to build everything, `docker-compose up` to start up the db and web server, then `docker-compose run web bundle exec rails db:setup` to create and seed the initial database. You can feed it commands like a normal Rails app by passing commands to the container using docker-compose. For example, `docker-compose run web bundle exec rails test` will run the test suite.

Once everything is working, the web server and db containers can be started up with `docker-compose up` and shut down with `docker-compose down`. The development environment is seeded with example data. Every account in the development environment has the password "badpassword". The administrator is named "Local Admin".

---

Higher priority tasks:

- Add a longer description field to each Tag for much more information about each. Grammar tags should have example sentences, Japanese terms, and possibly off-site links, a la Englipedia. This should help users get the gist of each grammar point more easily, provide more things for the built-in search to catch, and provide more fodder for search engines. This will be relatively easy to accomplish technically, but will require a lot of time to populate on the live site.
- Add a description field for Tag Categories to guide people on how to choose them when submitting an activity. For example, there probably shouldn't be more than 3 grammar point tags for a given activity.
- Add a flag for premium users. At first, these will be manually set to anyone who's contributed on Patreon or Ko-fi.
- Add several new fields to Users: School levels taught, a personal URL, and an avatar. Limit the latter two to premium users.

---

Longer-term tasks:

- Redo a lot of the development seeds
- Make embedded resources like /users/5/comments
- Add in a flag for "workshop" activities that premium users can create to request feedback
- Get the site working with webhooks to allow integration with Discord and Stripe
- Add in a purchasing system for premium accounts. Users will be able to purchase either subscriptions or non-recurring memberships that will apply a certain period of premium membership, after which their accounts will revert to regular accounts.
- Allow activities to link to specific textbook pages
- Switch permission management from Pundit to Cancancan. This will make the code in the controllers simpler since Cancancan allows standard controller methods to automatically load data for the current user given their permission level. This will likely involve rewriting a lot of integration tests since permission errors raise an exception instead of quietly failing.
- See if it's feasible to make a built-in chat system since Shoutbox is apparently breaking on a lot of browsers
- See what needs to be added for accessibility (screen readers and so on)
- De-emphasize the older versions of textbooks when they don't seem to be in use any more
- Scan all incoming files for viruses and warn moderators about them
- Look into localizing model data as well (tag data and activity text)
- Parse user-submitted text more thoroughly for HTML or other hinky stuff
- See if the fancy new text editor in Rails 6 can be used with Markdown, since that's how Activities and FrontPagePosts are formatted.

---

Lower-priority and smaller tasks:

- Potentially remove the "Solved" status for Comments, since that doesn't seem to have been very useful and it complicates comment code. Maybe it would be better replaced by a "visible" boolean value instead.

---

Pages to add or revise:

- A section for what to do during downtime at school - Japanese study, online study programs, programming tutorials, and so on.

---

Current bugs:
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display.

---

Pages that still need to be rebuilt or need fixes in the new interface:

- School level pages and others that overrun their width in IE11
- Tag Index page
- All Tag Category pages
- Activity index page
- Activity Link pages
