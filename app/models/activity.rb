class Activity < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

	has_many :upvotes, dependent: :destroy
  has_many :comments, as: :commentable
  belongs_to :user
  
  has_many_attached :documents
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :short_description, presence: true, length: { maximum: 200 }
  validates :long_description, presence: true, length: { maximum: 6000 } # up from 3000 - as always, subject to change
  #validates :tags, presence: true # I want to validate them, but it makes application submission break
	validates :upvote_count, numericality: { greater_than_or_equal_to: 0 }
  
  enum status: [:unapproved, :approved, :edited]
end
