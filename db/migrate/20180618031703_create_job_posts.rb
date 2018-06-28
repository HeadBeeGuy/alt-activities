
# One of the ways that we're thinking of funding the site is through job ads
# The idea is that, since ALTs are already on the site, perhaps companies and teachers would benefit
# from being able to browse and post job listings.
# Presently, these are just listings - if the user is interested, they follow an off-site link.
# Maybe at some point, users would be able to apply directly through a site account, but that's likely
# to be a much larger endeavor which should be addressed in more detail at a later date!
# Also, they will use UUIDs, which will, at present, necessitate the use of PostgreSQL in
# development and production.

class CreateJobPosts < ActiveRecord::Migration[5.2]
  def change
		enable_extension 'pgcrypto' unless extension_enabled?("pgcrypto") 
    create_table :job_posts, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.text :title
      t.string :external_url
      t.text :content
			t.integer :priority, default: 0

			t.references :user, foreign_key: true

      t.timestamps
    end

		add_index :job_posts, :created_at # UUIDs aren't sequential
		add_index :job_posts, :priority # may not be terribly necessary
  end
end
