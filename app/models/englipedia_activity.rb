class EnglipediaActivity < ApplicationRecord

  # validations will be pretty loose since the seed data has lots of quirks and
  # messy bits
  validates :title, length: { maximum: 200 }
  validates :author, length: { maximum: 200 }
  validates :submission_date, length: { maximum: 200 }
  validates :estimated_time, length: { maximum: 200 }
  validates :description, length: { maximum: 10000 }
end
