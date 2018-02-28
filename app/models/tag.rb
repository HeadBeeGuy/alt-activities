class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :activities, through: :taggings
  belongs_to :tag_category
  
  validates :short_name, presence: true, length: { maximum: 20 }
  validates :long_name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 100 }
end
