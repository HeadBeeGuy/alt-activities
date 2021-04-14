class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :activities, through: :taggings
  has_many :comments, as: :commentable
  has_many :textbook_pages, dependent: :destroy
  belongs_to :tag_category
  
  # these validations are for out-of-date data members
  validates :short_name, length: { maximum: 40 }
  validates :long_name, length: { maximum: 50 }

  # these are the only validations necessary from here on out
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :description, presence: true, length: { maximum: 100 }
  validates :explanation, length: { maximum: 2000 }

  include PgSearch::Model
  pg_search_scope :text_search, against: [:name, :description, :explanation],
    using: {
      tsearch: { dictionary: 'english' },
      trigram: {
        only: [:name],
        threshold: 0.2
      }
    },
    ranked_by: ":trigram"
  
  # used in pages like the Tag Search page in form labels
  def name_for_lists
    "#{name}###{description}"
  end

  def to_param
    "#{id}-#{self.name.parameterize.truncate(80, '')}"
  end
end
