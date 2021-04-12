# Adding some new data to User model:
# Teaching History, where a user can write out their experience
# A personal link to somewhere offsite - maybe premium only?
# A manual flag for if the user is a paid supporter - eventually this will be
# replaced by a more advanced system, hence "initial"
# A flag to specify if users want their favorites publicly displayed

class AddInitialPremiumToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :teaching_history, :string
    add_column :users, :offsite_link, :string
    add_column :users, :initial_premium, :bool, null: false, default: false
    add_column :users, :display_favorites, :bool, null: false, default: false
  end
end
