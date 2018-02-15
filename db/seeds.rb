

# going to seed Tags in directly - presently not planning to let them be created by users
# When the site's nearing release, I wonder if I could seed them in from a yaml file

Tag.create!(short_name: "ES", long_name: "Elementary School",
            description: "Activity appropriate for Elementary School")
            
Tag.create!(short_name: "JHS", long_name: "Junior High School",
            description: "Activity appropriate for Junior High School")
            
Tag.create!(short_name: "Listening", long_name: "Listening",
            description: "Students must listen during the activity")
            
Tag.create!(short_name: "Speaking", long_name: "Speaking",
            description: "Students must speak during the activity")
            
Tag.create!(short_name: "Writing", long_name: "Writing",
            description: "Students must write during the activity")
            
Tag.create!(short_name: "Past", long_name: "Past tense",
            description: "Uses the past tense")