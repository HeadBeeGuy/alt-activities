# The name is rather similar to "tag", so don't be confused.
# This class is the relationship between a tag and an activity.

class Tagging < ApplicationRecord
  belongs_to :activity
  belongs_to :tag
  
end
