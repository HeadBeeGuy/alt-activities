class Activity < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true
  validates :short_description, presence: true
  validates :long_description, presence: true
end
