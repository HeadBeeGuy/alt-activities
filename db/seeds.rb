

require 'yaml'
require 'faker'

# seed the development environment with enough stuff to create a reasonable fascimile of the site
if Rails.env.development?

  # seed in tags and tag categories from this yaml file
  tag_file = YAML.load_file('lib/seeds/tags.yaml')

  for current_category in 1..tag_file.length
    TagCategory.create!(name: tag_file["tag_category_#{current_category}"]["name"],
                        instruction: tag_file["tag_category_#{current_category}"]["instruction"],
                        suggested_max: tag_file["tag_category_#{current_category}"]["suggested_max"].to_i)
    for current_tag in 1..tag_file["tag_category_#{current_category}"]["tags"].length
      Tag.create!(name: tag_file["tag_category_#{current_category}"]["tags"]["tag_#{current_tag}"]["name"],
                  description: tag_file["tag_category_#{current_category}"]["tags"]["tag_#{current_tag}"]["description"],
                  explanation: Faker::Markdown.emphasis,
                  tag_category_id: current_category)
    end
  end

  # Seed a few users with specific roles
  admin_user = User.create!(username: "Local Admin",
                            email: "jake@example.com",
                            home_country: Faker::Games::Witcher.location,
                            location: Faker::Address.city,
                            bio: "I'm the admin user.",
                            teaching_history: Faker::University.name,
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :admin,
                            trusted: :true,
                            initial_premium: :true,
                            confirmed_at: Time.now)
                            
  moderator_user = User.create!(username: "Local Moderator",
                            email: "moderator@example.com",
                            home_country: Faker::Games::Witcher.location,
                            location: Faker::Games::ElderScrolls.region,
                            bio: "I'm the admin user.",
                            teaching_history: Faker::University.name,
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :moderator,
                            trusted: :true,
                            initial_premium: :true,
                            confirmed_at: Time.now)

  silenced_user = User.create!(username: "Silenced Saxton",
                            email: "call_me_sax@example.com",
                            home_country: Faker::Address.country[0..25],
                            location: Faker::Address.city,
                            bio: "I was a bad boy and I got silenced. Learn from my example!",
                            password: "badpassword",
                            password_confirmation: "badpassword",
                            role: :silenced,
                            trusted: :false,
                            confirmed_at: Time.now)

  # Randomly create regular users
  regular_users = []
  65.times do
    user_bio = Faker::Lorem.paragraph(random_sentences_to_add: 4) + "\n\n"
      + Faker::Lorem.paragraph
    regular_users << User.create!(username: Faker::Internet.unique.username(specifier: 6..15).delete("-_."),
                                  email: Faker::Internet.unique.safe_email,
                                  home_country: Faker::Address.country[0...25],
                                  location: Faker::Address.city,
                                  bio: user_bio,
                                  teaching_history: Faker::University.name,
                                  password: "badpassword",
                                  password_confirmation: "badpassword",
                                  role: :normal,
                                  trusted: :true,
                                  confirmed_at: Time.now)
  end
  
  # promote two random mods
  regular_users.sample(2).each do |user|
    user.moderator!
  end

  # untrust some of the users
  regular_users.sample(5).each do |user|
    user.untrust
  end

  regular_users.sample(6).each do |user|
    user.update(initial_premium: :true)
    user.update(display_favorites: :true)
  end

  # Randomly create some more tags - need to have enough to be greater than the
  # number in production, since I refer tags by id on the live site
  tag_category_ids = TagCategory.pluck(:id)

  80.times do |index|
    Tag.create!(name: "Extra Tag #{index}",
                description: "Description #{index}",
                tag_category_id: tag_category_ids.sample)
  end

  tag_ids = Tag.pluck(:id)

  es_tag = Tag.find_by_name("Elementary School")
  jhs_tag = Tag.find_by_name("Junior High School")
  hs_tag = Tag.find_by_name("High School")
  special_needs_tag = Tag.find_by_name("Special Needs")
  school_level_tags = [es_tag, jhs_tag, hs_tag, special_needs_tag]

  # Randomly create activities
  175.times do
    activity_tags = tag_ids.sample( Random.rand(5..15) )
    activity_text = Faker::Markdown.sandwich(sentences: 3) + "\n"
    Random.rand(1..6).times do
      activity_text += Faker::Lorem.paragraph(random_sentences_to_add: 5) + "\n"
    end
    activity = Activity.create!(name: Faker::Book.unique.title,
                                short_description: Faker::Hacker.say_something_smart,
                                long_description: activity_text,
                                user: regular_users.sample,
                                status: :approved,
                                tag_ids: activity_tags,
                                workshop: :false,
                                created_at: Time.now - Random.rand(0..365).days)

    # toss a school level on it because it's pretty important
    Tagging.find_or_create_by(activity: activity, tag: school_level_tags.sample)

    Random.rand(0..6).times do
      Comment.create!(commentable_type: "Activity",
                      commentable_id: activity.id,
                      user: regular_users.sample,
                      status: :normal,
                      content: Faker::Movies::Lebowski.quote,
                      created_at: Time.now - Random.rand(0..200).days)
    end

    Random.rand(0..17).times do
      Upvote.find_or_create_by(activity: activity,
                               user: regular_users.sample)
    end
  end

  # Generate activity counts for each user
  User.all.each do |user|
    user.update(activity_count: user.activities.count)
  end

  # Generate upvote count for each activity
  Activity.all.each do |activity|
    activity.update(upvote_count: activity.upvotes.count)
  end

  # create Front Page Posts
  7.times do
    fpp = FrontPagePost.create!(title: Faker::Lorem.sentence,
                                excerpt: Faker::Lorem.paragraph,
                                content: Faker::Hipster.paragraph_by_chars,
                                user: admin_user,
                                created_at: Time.now - Random.rand(0..100).days)

    Comment.create!(commentable_type: "FrontPagePost",
                    commentable_id: fpp.id,
                    user: regular_users.sample,
                    status: :normal,
                    content: Faker::Quotes::Shakespeare.romeo_and_juliet_quote,
                    created_at: Time.now - Random.rand(0..200).days)
  end

  # create Textbooks and populate them with pages
  grammar_tags = TagCategory.find_by_name("Grammar points").tags
  20.times do
    new_textbook = Textbook.create!(name: Faker::Lorem.sentence(word_count: 3),
                                    additional_info: Faker::TvShows::Simpsons.quote,
                                    level: Textbook.levels.to_a.sample[1],
                                    year_published: rand(1901..2099))
    Random.rand(10..25).times do
      TextbookPage.create!(textbook: new_textbook,
                           page: Random.rand(1..200),
                           description: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 5),
                           tag: grammar_tags.sample)
    end
  end

  40.times do
    Comment.create!(commentable_type: "Tag",
                    commentable_id: tag_ids.sample,
                    user: regular_users.sample,
                    status: :normal,
                    content: Faker::TvShows::DumbAndDumber.quote,
                    created_at: Time.now - Random.rand(0..200).days)
  end

  # Create activity links
  Activity.all.sample(10).each do |original_activity|
    inspired_activity = Activity.all.sample
    unless original_activity.id == inspired_activity.id
      ActivityLink.create!(original: original_activity,
                           inspired: inspired_activity)
    end
  end

  # Populate the mod queue
  Activity.all.sample(2).each do |activity|
    activity.unapproved!
  end
  Activity.all.sample(2).each do |activity|
    activity.request_moderator_check
  end
  Comment.all.sample(3).each do |comment|
    comment.unapproved!
  end

end
