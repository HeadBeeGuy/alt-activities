class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true, length: { maximum: 500 }

  enum status: [:unapproved, :normal, :solved]

  scope :visible, -> { where(status: :normal).or(where(status: :solved)) }
end
