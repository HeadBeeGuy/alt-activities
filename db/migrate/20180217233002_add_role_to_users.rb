# this is how varying user access levels will be handled on the site
# the general plan is adapted from https://stackoverflow.com/a/24480937
# at the time of this migration, current plan is to have the following roles in the following order:
# [ :silenced, :normal, :moderator, :admin ]
# note that the first status (index 0) is not what we want normal users to sign up as!
# hence, the default is 1

class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer, default: 1
  end
end
