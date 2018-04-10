# Let users give a bit more information about themselves
# This will all be optional
# Going for text rather than enumerations for locations, since I'm sure there will be users from places we never anticipated

class AddMoreInfoToUsers < ActiveRecord::Migration[5.2]
	def change
    add_column :users, :home_country, :string
    add_column :users, :location, :string
    add_column :users, :bio, :text
  end
end
