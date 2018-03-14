# TextbookPages are individual entries that are eventually collected into a Textbook object
# The idea is that they refer to an individual grammar point, referenced by a tag in the tag system
# The use case is that a teacher is covering, say, page 15 of Total English, and wants to find a relevant activity
# So they go to the Total English textbook page, find page 15, and upon clicking on the link, are directed to the relevant grammar tag

class CreateTextbookPages < ActiveRecord::Migration[5.1]
  def change
    create_table :textbook_pages do |t|
			# pages need to fall under a parent textbook!
			t.references :textbook, foreign_key: true

      t.integer :page
      t.text :description

			# pages are useful to specify because they can be linked to a tag. This will probably always be a grammar tag
			t.references :tag, foreign_key: true

      t.timestamps
    end
  end
end
