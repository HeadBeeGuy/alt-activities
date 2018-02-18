class Activity < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :short_description, presence: true, length: { maximum: 200 }
  validates :long_description, presence: true, length: { maximum: 2000 } # need to see how feasible this is in practice!
  #validates :tags, presence: true # I want to validate them, but it makes application submission break
end
