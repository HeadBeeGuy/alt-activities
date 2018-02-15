# This is how we'll tag activities!

class CreateTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :taggings do |t|
      t.integer :activity_id
      t.integer :tag_id

      t.timestamps
    end
    # sounds like it's really important to index these, since they'll be seeing frequent access
    # pinched it, as I often do, from Hartl's Rails tutorial. Sorry, Mike!
    add_index :taggings, :activity_id
    add_index :taggings, :tag_id
    add_index :taggings, [:activity_id, :tag_id], unique: true
  end
end
