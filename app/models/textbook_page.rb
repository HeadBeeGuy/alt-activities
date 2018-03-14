class TextbookPage < ApplicationRecord
	belongs_to :textbook
	belongs_to :tag

	validates :textbook_id, presence: true
	validates :page, presence: true, numericality: { greater_than: 0, less_than: 401 }
	validates :description, length: { maximum: 200 }
	# forcing a tag to be present may not be strictly necessary
	# we'll see if users find use cases that would benefit from pages without tags
	validates :tag_id, presence: true
end
