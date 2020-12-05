# Trusted users will be able to post activities that are visible immediately,
# but I'd still like to check when people modify activities, so this will be a
# flag that's set for edited activities. This might be unnecessary but I'll see
# how it goes.
# By default, Activities are checked, but the "unapproved" status flag takes
# precedence in hiding visibility.

class AddCheckedToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :checked, :bool, default: true
  end
end
