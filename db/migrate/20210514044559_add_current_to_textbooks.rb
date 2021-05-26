# This is a flag for active textbooks. Inactive textbooks will be separated
# visually, but there's no harm in keeping them around.

class AddCurrentToTextbooks < ActiveRecord::Migration[6.1]
  def change
    add_column :textbooks, :current, :bool, null: :false, default: :true
  end
end
