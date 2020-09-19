class FrontPagePost < ApplicationRecord
	belongs_to :user

	validates :title, presence: true, length: { maximum: 80 }
	validates :excerpt, length: { maximum: 1000 }
	validates :content, presence: true, length: { maximum: 15000 }

  has_many :comments, as: :commentable
  
  def to_param
    "#{id}-#{self.title.parameterize.truncate(80, '')}"
  end
end
