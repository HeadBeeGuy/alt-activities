class Tag < ApplicationRecord
  has_many :taggings
  has_many :activities, through: :taggings
  
  validates :short_name, presence: true, length: { maximum: 20 }
  validates :long_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
end
