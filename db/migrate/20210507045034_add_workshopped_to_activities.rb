# Adding a new supporter feature - Activities can be "workshopped", indicating
# that they are in development and inviting feedback from other users.

class AddWorkshoppedToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :workshop, :bool, null: :false, default: :false
  end
end
