class Textbook < ApplicationRecord

	has_many :textbook_pages

	validates :name, presence: true, length: { maximum: 50 }
	validates :additional_info, length: { maximum: 250 }

	enum level: [:general, :ES, :JHS, :HS, :University, :Conversation]
end
