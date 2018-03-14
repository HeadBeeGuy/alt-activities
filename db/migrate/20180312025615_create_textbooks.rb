# Textbooks essentially act as big containers for grammar points
# While not strictly necessary for the functioning of the site, many teachers need activities for specific grammar points
# covered in a particular textbook page
#
# the Textbook model will refer to the overall textbook itself
# the TextbookPage model refers to individual pages in each textbook
# I'm not quite sure if this is a naive implementation or if there's a more sophisticated way to construct this
class CreateTextbooks < ActiveRecord::Migration[5.1]
  def change
    create_table :textbooks do |t|
      t.string :name
			t.text :additional_info

      t.timestamps
    end
		
  end
end
