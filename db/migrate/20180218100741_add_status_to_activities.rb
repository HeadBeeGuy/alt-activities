# adding the Activity status as an integer enumeration
# maybe it would be sufficient to make it a boolean, but this may give more room for expansion in the future
# the idea behind this is that Activities need moderator/admin approval before they go live on the site
# plan for potential values at the time of creating this migration:
# [ :unapproved, :approved, :edited ]
# (edited means that it's been approved and submitted previously, but the user requested an edit)

class AddStatusToActivities < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :status, :integer, default: 0
  end
end
