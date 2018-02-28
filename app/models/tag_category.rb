class TagCategory < ApplicationRecord
  
  has_many :tags
  
  validates :name, presence: true, length: { maximum: 50 }
end
