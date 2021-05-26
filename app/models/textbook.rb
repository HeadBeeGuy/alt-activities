class Textbook < ApplicationRecord

	has_many :textbook_pages

	validates :name, presence: true, length: { maximum: 50 }
	validates :additional_info, length: { maximum: 250 }
  validates :year_published, numericality: { greater_than: 1900, less_than: 2100 }, allow_nil: true

	enum level: [:general, :ES, :JHS, :HS, :University, :Conversation]

  def to_param
    "#{id}-#{self.name.parameterize.truncate(80, '')}#{"-#{self.year_published}" unless self.year_published.nil?}"
  end

  def name_for_lists
    self.year_published.nil? ? self.name : self.name + " (#{self.year_published.to_s})"
  end

  scope :current, -> { where(current: :true) }
  scope :obsolete, -> { where(current: :false) }
end
