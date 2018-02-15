class Tag < ApplicationRecord
  has_many :taggings
  has_many :activities, through: :taggings
end
