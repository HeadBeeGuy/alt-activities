# first stab at the Activity model! This will eventually be the backbone of the site,
# but right now it's quite simple.

# no tags yet - that'll come in another migration

class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :short_description # information about the activity in lists
      t.text :long_description # information explaining how to perform the activity
      t.string :time_estimate # making it a string makes it less searchable but this is a pretty fuzzy concept to begin with
      
      # every activity is created by and attached to a user
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
