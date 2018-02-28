# ALT Activities


This web app is built to allow English teachers to share activities with each other.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students. It's not specifically restricted to this kind of activity, but that's the original intent of the site and will inform the initial design.

The core of the site is the **Activity** model. Activities have:

- A *User*, the original submitter
- A short description for display on an index page
- A longer description to describe how to perform the activity
- An estimate of how long it will take
- One or more *Tags*, which allow the site's users to search activities by attributes like which grammar point the activity targets, what size of class it's appropriate for, and lots of other information
- One or more files attached to it. Will probably use ActiveStorage through AWS.

**Tags** consist of:

- A brief name suitable for display in a list (like "Past tense" or "Elementary")
- A longer description 
- A category ("Grammar", "School level", and so on)

Users will be able to find an activity that suits their needs by browsing based on tags.

Users will have to register to submit an activity, but browsing the site and downloading activities will be available for users who don't have accounts. The site will use Devise for user accounts and allow users to sign up through OAuth providers.

When a user submits an activity, it goes into a moderator queue and must be approved before it's displayed on the site. Editing an activity will put it back in the queue.

---

Current list of things to implement:

- Tag categories
- Internationalization (English and Japanese initially)
- Uploading and attaching files, along with anti-virus scanning
- A **Textbook** model - Refers to specific textbooks and gives a page number with corresponding grammar point
- OAuth integration
- Thumbs-up system - Logged-in users can give a thumbs up to an activity, and activities are listed based on whichver has the most thumbs up in a given search
- Comment system (comments will also go through mod queue)
- Activity search system (will require some ActiveRecord/SQL wizardry to allow searches for required/optional tags)
- System for users to submit ideas for new tags or textbooks
- Report system for rule-breaking comments or activities

---

Current bugs:

- Usernames get saved as lowercase and don't allow spaces - Might have to do with the aftermarket Devise "login" code that lets you log in with username or e-mail
