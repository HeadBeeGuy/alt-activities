

require 'yaml'
require 'faker'

# seed in tags and tag categories from this yaml file
tag_file = YAML.load_file('lib/seeds/tags.yaml')

for current_category in 1..tag_file.length
  TagCategory.create!(name: tag_file["tag_category_#{current_category}"]["name"])
  for current_tag in 1..tag_file["tag_category_#{current_category}"]["tags"].length
    Tag.create!(short_name: tag_file["tag_category_#{current_category}"]["tags"]["tag_#{current_tag}"]["short_name"],
                long_name: tag_file["tag_category_#{current_category}"]["tags"]["tag_#{current_tag}"]["long_name"],
                description: tag_file["tag_category_#{current_category}"]["tags"]["tag_#{current_tag}"]["description"],
                tag_category_id: current_category)
  end
end

# seed the development environment with enough stuff to create a reasonable fascimile of the site
if Rails.env.development?

  # Seed a few users with specific roles
  admin_user = User.create!(username: "Jake the Local Admin",
                            email: "jake@example.com",
                            home_country: Faker::Address.country,
                            location: Faker::Address.city,
                            bio: "I'm the admin user.",
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :admin,
                            confirmed_at: Time.now)

  job_posting_user = User.create!(username: "Jimmy Jobposter",
                            email: "james@example.com",
                            home_country: Faker::Address.country_code_long,
                            location: Faker::Address.city,
                            bio: "I post jobs! Come and visit!",
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :job_poster,
                            confirmed_at: Time.now)
  
  silenced_user = User.create!(username: "Silenced Saxton",
                            email: "call_me_sax@example.com",
                            home_country: Faker::Address.country_code_long,
                            location: Faker::Address.city,
                            bio: "I was a bad boy and I got silenced. Learn from my example!",
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :silenced,
                            confirmed_at: Time.now)

  # Randomly create regular users
  regular_users = []
  25.times do
    regular_users << User.create!(username: Faker::Internet.unique.username(5..25).delete("-_."),
                                  email: Faker::Internet.safe_email,
                                  home_country: Faker::Address.country_code_long,
                                  location: Faker::Address.city,
                                  bio: Faker::FamousLastWords.last_words,
                                  password: "badpassword",
                                  password_confirmation: "badpassword",
                                  role: :normal,
                                  confirmed_at: Time.now)
  end
  
  # promote two random mods
  2.times do
    regular_users.sample.moderator!
  end

  es_tag = Tag.find_by_short_name("ES")
  jhs_tag = Tag.find_by_short_name("JHS")
  hs_tag = Tag.find_by_short_name("HS")
  conversation_tag = Tag.find_by_short_name("conversation")
  warmup_tag = Tag.find_by_short_name("warm-up")
  school_level_tags = [es_tag, jhs_tag, hs_tag, conversation_tag]

  # Randomly create activities
  # ideally, I should be able to pass in tag_ids as an array, but that's an
  # issue that's still baffling me
  60.times do
    activity = Activity.create!(name: Faker::Lovecraft.sentence(3, 1),
                                short_description: Faker::Company.bs,
                                long_description: Faker::Hipster.paragraph_by_chars,
                                user: regular_users.sample,
                                status: :approved,
                                created_at: Time.now - Random.rand(0..365).days)

    # Fill out each activity with tags, comments, and upvotes
    # at some point later I should add in attachments
    Random.rand(5..15).times do
      Tagging.find_or_create_by(activity: activity, tag: Tag.all.sample)
    end

    # toss a school level on it because it's pretty important
    Tagging.find_or_create_by(activity: activity, tag: school_level_tags.sample)

    # need to have a good selection of warm-ups as well
    if Random.rand(0..10) < 4
      Tagging.find_or_create_by(activity: activity, tag: warmup_tag)
    end

    Random.rand(0..6).times do
      Comment.create!(commentable_type: "Activity",
                      commentable_id: activity.id,
                      user: regular_users.sample,
                      status: :normal,
                      content: Faker::Lebowski.quote,
                      created_at: Time.now - Random.rand(0..200).days)
    end

    Random.rand(0..15).times do
      Upvote.find_or_create_by(activity: activity,
                               user: regular_users.sample)
    end
    CountUpvotesWorker.perform_async(activity.id)
  end

  # Generate upvote counts for each user
  User.all.each do |user|
    UpdateActivityCountWorker.perform_async(user.id)
  end

  # create Front Page Posts
  5.times do
    FrontPagePost.create!(title: Faker::Lorem.sentence(3),
                          excerpt: Faker::Simpsons.quote,
                          content: Faker::Hipster.paragraph_by_chars,
                          user: admin_user,
                          created_at: Time.now - Random.rand(0..100).days)
  end

  # create Textbooks and populate them with pages
  grammar_tags = TagCategory.find_by_name("Grammar points").tags
  20.times do
    new_textbook = Textbook.create!(name: Faker::Lorem.sentence(3),
                                    additional_info: Faker::Simpsons.quote,
                                    level: Textbook.levels.to_a.sample[1])
    Random.rand(10..20).times do
      TextbookPage.create!(textbook: new_textbook,
                           page: Random.rand(1..200),
                           description: Faker::Lorem.sentence(3, true, 7),
                           tag: grammar_tags.sample)
    end
  end

end
