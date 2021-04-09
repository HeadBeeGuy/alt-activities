class TagCategory < ApplicationRecord
  
  has_many :tags
  
  validates :name, presence: true, length: { maximum: 50 }

  def to_param
    "#{id}-#{self.name.parameterize.truncate(80, '')}"
  end
end
