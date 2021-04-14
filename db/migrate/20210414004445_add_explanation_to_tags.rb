# Explanations will be several paragraphs of Markdown-encoded text that 
# explains each grammar point in greater detail.
# There's still the "short description" and "long description" columns in the
# Tag model, but I think I'll make this new column and take those two out at
# some point in the near future.

class AddExplanationToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :explanation, :text
  end
end
