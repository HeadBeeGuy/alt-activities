# Now tags will be associated with one particular Tag Category
# Since there are a ton of potentially useful tags, they would become very hard to browse if they were just one giant list
# This will simplify their display for when users are creating activities or searching the site

class AddTagCategoryIdToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :tag_category_id, :integer, foreign_key: true
    
    # sounds like this might give it a name of something like fk_rails_###?
    # if so, it wouldn't fit in with the current column names
    #add_foreign_key :tags, :tag_categories
  end
end
