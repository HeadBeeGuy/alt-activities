

require 'yaml'

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