# This is a flag for each user account that will account for whether or not the
# user can be trusted to make modifications to activities without the
# activities automatically being pulled from public visibility. The current
# plan (as of December 2020) is to set this manually for just about any account
# that's contributed positively to the site. It will be off by default for new
# accounts as a spam prevention measure

class AddTrustedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :trusted, :bool, default: false

    # automatically trust the most active users
    User.where("activity_count > 5").each do |user|
      user.trust
    end
  end
end
