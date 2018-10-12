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
- OAuth integration - or maybe not, if the big OAuth providers keep behaving badly!
- Activity search system (likely an AND search on activities with certain tags. Maybe just use Google or another search provider for text searches?)
- System for users to submit ideas for new tags or textbooks
- Report system for rule-breaking comments or activities
- Look into localizing model data as well (tag data and activity text)
- Parse user-submitted text more thoroughly for HTML or other hinky stuff
- Add in functionality to generate activity URLs based on their name (something like /activities/greatest-bingo-game-ever) and make that the default URL for any given activity
- Add a captcha to user registration and possibly activity submission for accounts that don't have any approved activities
- Restrict the file types and file size of uploaded files. ActiveStorage does not appear to have this built into it, so this could be challenging!
- Add Ajax to comment submission, deletion, and approval
- Rewrite site CSS to get away from Bootstrap - its Flexbox classes have been frustrating to work with, and I feel like we'll eventually outgrow its limits. It's possible to heavily customize Bootstrap, but this may be more work in the end than just building the site's CSS from scratch.

---

Smaller tasks:

- A function to generate yaml files for localization. It needs to take the en.yml file and automatically insert any missing strings into localized yml files.
- Clean up CRUD actions and add tests for Tag Categories
- Make the grammar page look less ugly
- Improve the textbook index page - sort by level and make them look a lot less ugly

---

Current bugs:
 
- If a user submits an activity that fails validation (like a text field being too long) and they attached files, it generates a server error instead of returning them to the form with an error message display.
- The top warm-up display in the school-level landing pages doesn't actually sort the activities like it should
