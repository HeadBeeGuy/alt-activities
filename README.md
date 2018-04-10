# ALT Activities


This web app is built to allow English teachers to share activities with each other.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students.

The core of the site is the **Activity** model. Activities have:

- A *User*, the original submitter
- A short description for display on an index page
- A longer description to describe how to perform the activity
- An estimate of how long it will take
- One or more *Tags*, which allow the site's users to search activities by attributes like which grammar point the activity targets, what size of class it's appropriate for, and lots of other information
- One or more files attached to it. This will necessitate an upgrade to Rails 5.2 to use ActiveStorage.

Users will be able to find an activity that suits their needs by browsing based on tags.

Users will have to register to submit an activity, but browsing the site and downloading activities will be available for users who don't have accounts.

When a user submits an activity, it goes into a moderator queue and must be approved before it's displayed on the site. Editing an activity will put it back in the queue.

---

Larger implementation tasks:

- Take a deeper look at how taggings are generated during activity creation. I didn't whitelist the parameter as an array correctly, but when I do that, activity creation breaks. This also causes problems when the server is processing file uploads for ActiveStorage and locks the database.
- Scan all incoming files for viruses and warn moderators about them
- OAuth integration
- Thumbs-up system - Logged-in users can give a thumbs up to an activity, and activities are listed based on whichver has the most thumbs up in a given search
- Comment system (comments will also go through mod queue)
- Activity search system (will require some ActiveRecord/SQL wizardry to allow searches for required/optional tags)
- System for users to submit ideas for new tags or textbooks
- Report system for rule-breaking comments or activities
- Customize the Bootstrap layout so it doesn't look so generic
- Look into localizing model data as well (primarily tag information)
- Allow users to give more information about themselves (location, what level of school they teach)
- Add in :ominauthable, :confirmable, and more with Devise

---

Smaller tasks:

- A function to generate yaml files for localization. It needs to take the en.yml file and automatically insert any missing strings into localized yml files.
- Make the textbook page generator more compact and suitable for multiple inclusion into a page so the pages can be generated in bulk using Ajax
- Clean up CRUD actions and add tests for Tag Categories
- Pull more of the site text into en.yml so it can be localized
- Add pagination so activity lists don't become unreadably large as the site grows (maybe with the Kaminari gem?)
- Add something that lets users manage and delete attached files when editing activities

---

Current bugs:

- Usernames get saved as lowercase and don't allow spaces - Might have to do with the aftermarket Devise "login" code that lets you log in with username or e-mail
 

