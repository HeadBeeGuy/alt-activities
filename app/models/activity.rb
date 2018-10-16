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

  # adapted from https://stackoverflow.com/a/33558154
  # and https://stackoverflow.com/a/11299725
  # search_tags must be an array of integers, specifically the IDs of the tags
  # this is likely an inept way to do this, but upon much searching, it appears that
  # SQL intersects aren't part of ActiveRecord. How I wish they was!
  # this works in Postgres, but who knows if it will work with other DBs
  def self.find_with_all_tags(search_tags, limit)
    intersect_query = ""
    search_tags.each_with_index do |tag_id, i|
      return nil unless tag_id.is_a? Integer # will this actually thwart any sort of injection attack?
      intersect_query += "SELECT activity_id FROM taggings WHERE tag_id = ?"
      intersect_query += " INTERSECT " if i != search_tags.length - 1
    end

    # Constructing an array of Activity objects - will this hog a lot of memory?
    # extracting activities is clunky, but unless I queried Tagging, it wouldn't return results
    # I doubt this query will scale well, but I'm not anticipating that the tags will get too numerous
    activity_array = []
    Tagging.find_by_sql([intersect_query, *search_tags]).each do |tagging|
      activity_array << tagging.activity
    end

    # this is probably not good Ruby, but reverse! wasn't actually saving the sorted array
    activity_array = activity_array.sort_by { |activity| activity.upvote_count }.reverse
      .select { |activity| activity.approved? }

    # activity_array = activity_array.select { |activity| activity.approved? }
    # take! doesn't appear to exist. Will there be two copies of this array in memory?
    activity_array.take(limit)
  end

end
