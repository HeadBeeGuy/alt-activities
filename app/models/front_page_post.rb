class FrontPagePost < ApplicationRecord
	belongs_to :user, dependent: :destroy

	validates :title, presence: true, length: { maximum: 250 }
	validates :excerpt, length: { maximum: 1000 }
	validates :content, presence: true, length: { maximum: 5000 }
end
