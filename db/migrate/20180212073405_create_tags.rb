class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :short_name # for reference in lists
      t.string :long_name # a longer name (i.e. "Junior High School")
      t.text :description # describes what this tag is for

      t.timestamps
    end
    # I haven't been good about adding indexes thus far
    add_index :tags, :short_name
  end
end
