class EnglipediaActivity < ApplicationRecord

  # validations will be pretty loose since the seed data has lots of quirks and
  # messy bits
  validates :title, length: { maximum: 200 }
  validates :author, length: { maximum: 200 }
  validates :submission_date, length: { maximum: 200 }
  validates :estimated_time, length: { maximum: 200 }
  validates :description, length: { maximum: 10000 }

  def convert_to_regular_activity
    new_description = "**Archived from Englipedia.**\n"
    new_description << "**Originally submitted by #{author} on #{submission_date}.**\n\n"
    new_description << description

    listening_tag = Tag.find_by_long_name("Listening")
    speaking_tag = Tag.find_by_long_name("Speaking")
    reading_tag = Tag.find_by_long_name("Reading")
    writing_tag = Tag.find_by_long_name("Writing")

    @new_activity = Activity.create!(name: title,
                                     short_description: "Add the short description stuff in, Jake!",
                                     long_description: new_description,
                                     user: User.first,
                                     time_estimate: estimated_time,
                                     status: :unapproved)

    @new_activity.tags << listening_tag if listening?
    @new_activity.tags << speaking_tag if speaking?
    @new_activity.tags << reading_tag if reading?
    @new_activity.tags << writing_tag if listening?

    # attach files... this might be a doozy!
  end
end
