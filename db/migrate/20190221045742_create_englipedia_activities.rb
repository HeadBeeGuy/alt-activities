# This model represents activities posted to the Englipedia site. They'll be
# seeded in manually (via this migration) from yaml files that were already
# generated from spidering the site. Instances of this model should be fairly
# temporary and once we've pulled everything we want to from Englipedia, I can
# just remove the model.

require 'yaml'

class CreateEnglipediaActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :englipedia_activities do |t|
      t.string :title
      t.string :author
      t.string :submission_date
      t.string :estimated_time
      t.string :original_url

      # as with UUIDs, this may only work in Postgres
      t.text :attached_files, array: true, default: '{}'

      t.boolean :warmup
      t.boolean :es
      t.boolean :jhs
      t.boolean :hs
      
      t.boolean :speaking
      t.boolean :listening
      t.boolean :reading
      t.boolean :writing

      t.text :outline

      t.text :description

      # This is set to true once the ALTopedia version of the activity is
      # created - then we'll know it's okay to delete it.
      t.boolean :converted, default: false
      t.timestamps
    end

    # Seed the data for all of these at this point and only this point
    Dir.glob("lib/seeds/englipedia/*.txt") do |file|
      data = YAML.load(File.read(file))
      unless data[:title].nil?
        EnglipediaActivity.create!(title: data[:title],
                                   author: data[:author],
                                   submission_date: data[:submission_date],
                                   original_url: data[:original_url],
                                   estimated_time: data[:estimated_time],
                                   warmup: data[:level_info][:warmup],
                                   es: data[:level_info][:es],
                                   jhs: data[:level_info][:jhs],
                                   hs: data[:level_info][:hs],
                                   speaking: data[:parts_of_learning][:speaking],
                                   listening: data[:parts_of_learning][:listening],
                                   reading: data[:parts_of_learning][:reading],
                                   writing: data[:parts_of_learning][:writing],
                                   attached_files: data[:attached_files],
                                   outline: data[:outline],
                                   description: data[:description])
      end
    end
  end

  @archive_user = User.create(username: "Englipedia Archive",
                              email: "englipedia_archive@example.org",
                              home_country: "Cyberspace",
                              location: "Japan",
                              bio: "Archived activities from the Englipedia site.",
                              password: "badpassword",
                              password_confirmation: "badpassword",
                              role: :normal,
                              confirmed_at: Time.now)

  @archive_user.save

end
