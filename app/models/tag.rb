class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :activities, through: :taggings
  has_many :comments, as: :commentable
  belongs_to :tag_category
  
  validates :short_name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :long_name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 100 }
  
  # Adding this because the activity creation form uses collection_check_boxes to display a checkbox for each tag in each category
  # It needs a symbol to pass in to generate the "label"
  def name_for_lists
    "#{long_name} - #{description}"
  end
end
