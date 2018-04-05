
# Adding in an enumeration to the Textbook model to specify its level
# This doesn't feel like the most elegant way to do it, but other approaches didn't seem to be great either
# Assigning a textbook a tag seems a bit iffy, since only a few tags of many are relevant to the textbook level
# Making a separate model to house school level info seems like overkill
# Disadvantages of this enumeration approach: Localization may be quite tricky indeed, and additional levels will be tough to add
# Perhaps I'll pay for my ineptitude later! But I don't want to hem and haw forever and let this slow or stop development of the site

class AddLevelToTextbooks < ActiveRecord::Migration[5.2]
  def change
		add_column :textbooks, :level, :integer, default: 0
  end
end
