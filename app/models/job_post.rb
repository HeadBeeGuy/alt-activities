class JobPost < ApplicationRecord
	belongs_to :user

	validates :title, presence: true, length: { maximum: 400 }
	validates :external_url, length: { maximum: 250 }
	validates :content, presence: true, length: { maximum: 5000 }

	enum priority: [:normal, :site_sponsor, :primary_sponsor ]

	has_one_attached :company_logo
	has_many_attached :post_images

end
