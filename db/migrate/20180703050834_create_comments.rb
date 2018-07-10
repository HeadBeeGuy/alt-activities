
# Comments! What would the internet be without 'em?
# This is my first stab at a polymorphic association, so please excuse any ineptitude
# in my execution.
# Presently, I'm intending users to be able to comment on activities, tags, and front
# page posts. Comments will be sent to the mod queue for approval before they're viewable.
# Comments can be marked as "addressed" or "solved" when they point out something that's since
# been fixed. This will fade them out but not delete them.
# Silenced users can't post comments, naturally.
# There's no real reason to store comments with a sequential ID, so I'll use UUIDs.

class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.text :content
      t.integer :status, default: 0
      t.references :user, foreign_key: true

      t.references :commentable, polymorphic: true, index:true

      t.timestamps
    end

    add_index :comments, :created_at
  end
end
