# As more users join the site, it might be useful to display how many successful activities they've
# submitted to the site. We could do things like sort the user index page based on who has the most.
# This will be an integer that houses that count.
# Of course, it would be easy to just do "@user.activities.count", but as the Activity table grows large,
# this might be a pretty expensive query to run, especially on the Contributors page, where 20 or more
# users are listed. 
# Thus, we'll generate the count with a background job whenever we have reason to believe that the 
# number should change - activity approval, editing, or deletion.
# The intent is to make this an indicator of a user's contribution level, but not much more than that.
# I don't want to create incentives for users to submit a lot of seperate, low-quality activities in
# search of some kind of perk that comes with a high activity count.
#

class AddActivityCountToUsers < ActiveRecord::Migration[5.2]
  def change
		add_column :users, :activity_count, :integer, default: 0
  end
end

# I haven't done this before, but I hope it works. Since we have to work with production data now, 
# existing users will need to have their count generated. As I write this, there are only about 10 
# user accounts on the live site, so it shouldn't be very computationally expensive.

User.all.each do |user|
	UpdateActivityCountWorker.perform_async(user.id)
end
