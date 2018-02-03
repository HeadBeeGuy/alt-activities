# ALT Activities


This web app is built to allow English teachers to share activities with each other.

It's more specifically designed around the needs of ALTs, (public school English teachers in Japan) who are creating activities to target a certain English grammar point for a class of elementary, junior high, or high school students. It's not specifically restricted to this kind of activity, but that's the original intent of the site and will inform the initial design.

It's a Ruby on Rails app, designed when 5.1.4 was the most recent version. As of writing, 5.2 is on the horizon and ActiveStorage looks like it might be useful, but we'll have to wait until further along in the project to see if it's feasible to upgrade.

The core of the site will be the **Activity** model. Every activity will have:

- A *User*, the original submitter
- A short description for display on an index page
- A longer description to describe how to perform the activity
- An estimate of how long it will take
- One or more *Tags*, which allow the site's users to search activities by attributes like which grammar point the activity targets, what size of class it's appropriate for, and lots of other information
- One or more files attached to it. Often Word documents, but could be PDFs or PPTs. Will need to make sure that these aren't infected! Going no-files would make security much easier but the site potentially much less useful to users

**Tags** will be another model. They'll consist of:

- A brief name suitable for display in a list (like "Past tense" or "Elementary")
- Possibly a category, which might need to be its own model (example: "Grammar", "School level")
- A longer description 

Users will be able to find an activity that suits their needs by browsing based on tags. Views will be robust enough to where a user doesn't need to be aware of what a tag is, just that they're going through several categories and paring down the displayed activities to what's relevant to them.

The tag system is what will distinguish this site from similar sites, which are often implemented as wikis. If every activity is tagged, it will be much easier to find activities that suit more specific situations.

Users will have to register to submit an activity, but browsing the site and downloading activities will be available for users who don't have accounts. The site will use Devise for user accounts and allow users to sign up through OAuth providers.

Of course, any site that allows user-submitted content will inevitably have to deal with spam or other bad actors. Activities will get placed into a moderator queue to be approved by users flagged as moderators before they go live on the site. Revisions will go through the same system for approval.

---

Gems/Supporting software packages 
- Devise
- Pundit for user roles?
- Haml, since I find it a lot easier to look at than ERB
- PostgreSQL (I considered a NoSQL database like MongoDB but I thought I'd need more Rails experience before breaking away from Rails' more well-worn use of RDBMS systems)
- No particular preference on the web server - whatever works well!

---

Initial site (not staged anywhere important or robust)
- Activity submission
- Tagging working
- Internationalization (English and Japanese) - This needs to be supported as early as possible. Unsure of how much control I'll have of the domain name or TLD of the final site, so by default it will be the language id after the base URL (http://example.com/en/)
- Moderator queue
- Antivirus scanning on submitted files

---

Beta level (can be seen by people who aren't directly involved with the site, possible data persistence)
- OAuth integration
- Activity updates and deletion

---

Longer-term goals:

- Thumbs-up system - Logged-in users can give a thumbs up to an activity, and activities are listed based on whichver has the most thumbs up in a given search
- A **Textbook** model - Refers to specific textbooks and gives a page number with corresponding grammar point
- Comment system
- System for users to submit ideas for new tags or textbooks
- Report system for rule-breaking comments or activities