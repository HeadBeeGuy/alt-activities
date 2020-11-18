# The site has operated long enough to where there are new textbook revisions
# coming in, and distinguishing them from textbooks in other years will be
# important. This information may not be available for all textbooks, so it
# will be an optional data point.

class AddYearPublishedToTextbooks < ActiveRecord::Migration[6.0]
  def change
    add_column :textbooks, :year_published, :integer
  end
end
