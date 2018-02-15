# The name is rather similar to "tag", so don't be confused.
# This class is the relationship between a tag and an activity.

class Tagging < ApplicationRecord
  belongs_to :activity
  belongs_to :tag
  
  validates :activity_id, presence: true
  validates :tag_id, presence: true
end
