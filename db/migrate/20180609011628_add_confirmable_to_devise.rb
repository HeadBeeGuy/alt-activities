# From this point, users will need to confirm their e-mail before signing up
# copying this code from the Devise wiki
class AddConfirmableToDevise < ActiveRecord::Migration[5.2]
  def up
		# these columns should already be present on the production server
		# had a bit of a weird issue where I reverted this and lost the colums in development
		# I had to run this again with the lines uncommented, but I'm worried that the
		# migration will fail in production, so I'm re-commenting them out
		# Hopefully Rails won't notice that the migration changed in development!
		#

		# add_column :users, :confirmation_token, :string
		# add_column :users, :confirmed_at, :datetime
		# add_column :users, :confirmation_sent_at, :datetime
		# add_index :users, :confirmation_token, unique: true

		# I didn't set up :reconfirmable initially, so adding this column
		add_column :users, :unconfirmed_email, :string

		# everyone who's signed up already gets a free pass
		User.all.update_all confirmed_at: DateTime.now
  end

	def down
		remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email
	end
end
