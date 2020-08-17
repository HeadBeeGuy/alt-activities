require 'open-uri'

class EnglipediaActivity < ApplicationRecord

  # validations will be pretty loose since the seed data has lots of quirks and
  # messy bits
  validates :title, length: { maximum: 200 }
  validates :author, length: { maximum: 200 }
  validates :submission_date, length: { maximum: 200 }
  validates :estimated_time, length: { maximum: 200 }
  validates :description, length: { maximum: 50000 }

  def convert_to_regular_activity
    new_description = "**Archived from Englipedia.**\n"
    new_description << "**Originally submitted by #{author} on #{submission_date}.**\n\n"
    new_description << description

    listening_tag = Tag.find_by_long_name("Listening")
    speaking_tag = Tag.find_by_long_name("Speaking")
    reading_tag = Tag.find_by_long_name("Reading")
    writing_tag = Tag.find_by_long_name("Writing")

    warmup_tag = Tag.find_by_long_name("Warm-up")
    es_tag = Tag.find_by_long_name("Elementary School")
    jhs_tag = Tag.find_by_long_name("Junior High School")
    hs_tag = Tag.find_by_long_name("High School")

    @new_activity = Activity.create!(name: title,
                                     short_description: outline,
                                     long_description: new_description,
                                     user: User.find_by_username("Englipedia Archive"),
                                     time_estimate: estimated_time,
                                     status: :unapproved)

    @new_activity.tags << listening_tag if listening?
    @new_activity.tags << speaking_tag if speaking?
    @new_activity.tags << reading_tag if reading?
    @new_activity.tags << writing_tag if listening?
    @new_activity.tags << warmup_tag if warmup?
    @new_activity.tags << es_tag if es?
    @new_activity.tags << jhs_tag if jhs?
    @new_activity.tags << hs_tag if hs?

    self.update(converted: true)

    # thanks to https://stackoverflow.com/a/54185936
    if attached_files.any?
      file_location = "http://englipedia.co/www.englipedia.net/Documents/"
      attached_files.each do |englipedia_file|
        file_url = "#{file_location}#{englipedia_file.split('/').last}"
        begin
          @new_activity.documents.attach(io: open(file_url),
                                         filename: englipedia_file.split('/').last)
        rescue OpenURI::HTTPError => ex
          # the file 404ed - nothing to do but ignore and move on!
          next
        end
      end
    end

    @new_activity
  end
end
