# ALTopedia


This web app is built to allow English teachers to share activities with each other.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The site is primarily built around the **Activity** model, which contains directions and information for any activity that a teacher could use in an English class. Activities are submitted by users through a standard web form, but they have to be reviewed by a moderator before they're posted on the live site.

Activities can be assigned a variety of tags to help categorize them. By searching based on tags, users can find relevant activities for their particular needs (like school level, targetted grammar pattern, relevant materials).

Storage and hosting are being built for AWS, but can be adapted to other platforms as necessary.

---

Larger implementation tasks:

- Take a deeper look at how taggings are generated during activity creation. I didn't whitelist the parameter as an array correctly, but when I do that, activity creation breaks. This also causes problems when the server is processing file uploads for ActiveStorage and locks the database.
- Scan all incoming files for viruses and warn moderators about them
- OAuth integration
- Comment system (comments will also go through mod queue)
- Activity search system (will require some ActiveRecord/SQL wizardry to allow searches for required/optional tags)
- System for users to submit ideas for new tags or textbooks
- Report system for rule-breaking comments or activities
- Customize the Bootstrap layout so it doesn't look so generic
- Look into localizing model data as well (primarily tag information)
- Add in :ominauthable, :confirmable, and more with Devise
- Add in a footer that sticks to the bottom of the page correctly.
- Parse user-submitted text more thoroughly for HTML or other hinky stuff
- Evaluate if the subdomain can be used as the language-switching mechanism
- Add in functionality to generate activity URLs based on their name (something like /activities/greatest-bingo-game-ever) and make that the default URL for any given activity

---

Smaller tasks:

- A function to generate yaml files for localization. It needs to take the en.yml file and automatically insert any missing strings into localized yml files.
- Clean up CRUD actions and add tests for Tag Categories
- Pull more of the site text into en.yml so it can be localized
- Add something that lets users manage and delete attached files when editing activities
- Customize login and signup forms
- Draft up activity submission guidelines and site rules
- Add partials to display top 5 rated/newest activities in given categories in a compact format
- Change the mod queue to a general admin/moderator control center with links to tag creation and so on
- Restrict the file types and file size of uploaded files.

---

Current bugs:
 
- Users can likely alter their username and e-mail through directly submitting a POST request, even though only admins should be allowed to do this. Might need to build another whitelist parameter set for editing?

