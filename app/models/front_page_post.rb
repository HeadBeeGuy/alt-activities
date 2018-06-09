class FrontPagePost < ApplicationRecord
	belongs_to :user

	validates :title, presence: true, length: { maximum: 250 }
	validates :excerpt, length: { maximum: 1000 }
	validates :content, presence: true, length: { maximum: 3000 }
end
