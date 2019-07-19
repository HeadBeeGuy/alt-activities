# Activity links are simple associations between two activities
# This will let users say that their activity was inspired by or related to another

class CreateActivityLink < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_links do |t|
      
      # ideally I'd like to make these original_activity_id and inspired_activity_id
      t.integer :original_id
      t.integer :inspired_id
      t.text :explanation

      t.timestamps
    end

    add_index :activity_links, :original_id
    add_index :activity_links, :inspired_id
    # ..but it leads to this index having a name that's too long
    add_index :activity_links, [:original_id, :inspired_id], unique: true
  end
end
