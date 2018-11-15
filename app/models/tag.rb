class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :activities, through: :taggings
  has_many :comments, as: :commentable
  belongs_to :tag_category
  
  # short_name was what I thought would be the slug before I knew about parameterize
  # I should probably just get rid of it at some point and have only "name"
  validates :short_name, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :long_name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 100 }
  
  # Adding this because the activity creation form uses collection_check_boxes to display a checkbox for each tag in each category
  # It needs a symbol to pass in to generate the "label"
  def name_for_lists
    "#{long_name} - #{description}"
  end

  # swiped wholesale from https://old.reddit.com/r/ruby/comments/9qpbok/custom_urls_in_ruby_on_rails_how_you_can_use/e8azvb9/
  def to_param
    "#{id}-#{self.long_name.parameterize.truncate(80, '')}"
  end
end
