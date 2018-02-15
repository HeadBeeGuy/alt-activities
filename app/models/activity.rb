class Activity < ApplicationRecord
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
  
  validates :name, presence: true
  validates :short_description, presence: true
  validates :long_description, presence: true
end
