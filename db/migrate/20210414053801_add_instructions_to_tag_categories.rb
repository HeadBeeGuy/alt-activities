# In the Activity form, these will act as guidance to users selecting tags.
 
class AddInstructionsToTagCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :tag_categories, :instruction, :text
    add_column :tag_categories, :suggested_max, :integer, default: 0
  end
end
