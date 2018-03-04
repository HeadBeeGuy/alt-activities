class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :activities, through: :taggings
  belongs_to :tag_category
  
  validates :short_name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :long_name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 100 }
end
