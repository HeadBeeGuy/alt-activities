
# This will be the join table that holds users' activity upvotes
# The intent of this system is to give users a way to give positive feedback for activities
# "If you like it, give it a thumbs up!"
# We're making a conscious decision to only allow voting in one direction - you can withdraw an upvote, but there are no downvotes
# We'll see how it pans out in the end, but hopefully this will encourage positive interactions and minimize the negative
# Counting and displaying these will require some care so as to not completely fall down at scale

class CreateUpvotes < ActiveRecord::Migration[5.2]
  def change
    create_table :upvotes do |t|
      t.integer :user_id
      t.integer :activity_id

      t.timestamps
    end
		add_index :upvotes, :user_id
		add_index :upvotes, :activity_id
		add_index :upvotes, [:user_id, :activity_id], unique: true

		add_column :activities, :upvote_count, :integer, default: 0
  end
end
