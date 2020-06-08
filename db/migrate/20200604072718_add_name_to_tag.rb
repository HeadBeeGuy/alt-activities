# Tags have both a "short_name" and "long_name" field, but I came up with those
# before I knew about how to parameterize URLs. There only really needs to be
# one "name" field, so that's what this will be. This will make it easier if I
# implement a more sophisticated search method like pg-search. If nothing else,
# it will remove one confusing and unnecessary bit of the codebase. I'll try
# and remove the old short_name and long_name fields once it's reasonably
# certain that it won't cause any problems.

class AddNameToTag < ActiveRecord::Migration[5.2]
  def change
    add_column :tags, :name, :string

    Tag.all.each do |tag|
      tag.update!(name: tag.long_name)
    end
  end
end
