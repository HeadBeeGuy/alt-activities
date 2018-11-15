class Textbook < ApplicationRecord

	has_many :textbook_pages

	validates :name, presence: true, length: { maximum: 50 }
	validates :additional_info, length: { maximum: 250 }

	enum level: [:general, :ES, :JHS, :HS, :University, :Conversation]

  # swiped wholesale from https://old.reddit.com/r/ruby/comments/9qpbok/custom_urls_in_ruby_on_rails_how_you_can_use/e8azvb9/
  def to_param
    "#{id}-#{self.name.parameterize.truncate(80, '')}"
  end
end
