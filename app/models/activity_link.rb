class ActivityLink < ApplicationRecord
  belongs_to :original, class_name: "Activity"
  belongs_to :inspired, class_name: "Activity"

  # the explanation is optional
  validates :explanation, length: { maximum: 100 }

  validates :original_id, presence: true
  validates :inspired_id, presence: true

end
