# This is a pretty standard join model. The idea is to let users link their
# activities with specific textbook pages.

class CreateTextbookPageLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :textbook_page_links do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :textbook_page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
