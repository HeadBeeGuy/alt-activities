class TagCategory < ApplicationRecord
  
  has_many :tags
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :instruction, length: { maximum: 500 }
  validates :suggested_max, numericality: { greater_than_or_equal_to: 0,
    less_than_or_equal_to: 20 }

  def to_param
    "#{id}-#{self.name.parameterize.truncate(80, '')}"
  end
end
