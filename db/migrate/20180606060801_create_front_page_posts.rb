# Right now, the front page is rather drab, and we need to be able to communicate with users
# I'm resisting adding a general CMS, as I worry it might add too much complexity
# Perhaps that will eventually be how we'll need to go, but for now, I'll try this very basic model
# Presently, only admins will be allowed to write or edit these posts

class CreateFrontPagePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :front_page_posts do |t|
      t.text :title
			t.text :excerpt # brief summary (or partial excerpt) of the full post
      t.text :content # the full text of the post
      
			t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
