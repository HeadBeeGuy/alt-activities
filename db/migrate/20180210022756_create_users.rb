class CreateUsers < ActiveRecord::Migration[5.1]
  # The embryonic user model - lots of other stuff will get added with Devise
  def change
    create_table :users do |t|
      t.string :username, null: false

      t.timestamps
    end
  end
end
