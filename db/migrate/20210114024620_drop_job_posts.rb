# The job ad posts are vestigial and no longer necessary. May as well clear 'em
# out!
class DropJobPosts < ActiveRecord::Migration[6.1]
  def change
    drop_table :job_posts
  end
end
