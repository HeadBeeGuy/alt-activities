class FrontPagePost < ApplicationRecord
	belongs_to :user

	validates :title, presence: true, length: { maximum: 250 }
	validates :excerpt, length: { maximum: 1000 }
	validates :content, presence: true, length: { maximum: 5000 }

  has_many :comments, as: :commentable
end
