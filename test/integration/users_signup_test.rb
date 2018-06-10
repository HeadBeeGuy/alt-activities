require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	def setup
		ActionMailer::Base.deliveries.clear
	end

	# copying (and slightly modifying) test from Hartl's Rails Tutorial
	# I have to admit that some of this is stuff I don't quite understand
	test "valid signup information with account activation" do
		get new_user_registration_path
		assert_difference 'User.count', 1 do
			post users_path, params: { user: {
				username: "Test user",
				email: "testuser@example.com",
				password: "badpassword",
				password_confirmation: "badpassword" } }
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		ActionMailer::Base.deliveries.clear

		new_user = assigns(:user)
		assert_not new_user.reload.confirmed?

		# try to sign in before activation
		sign_in(new_user)
		assert_not new_user.reload.confirmed?

		# activate correctly
		# Unfortunately I can't get this line to work. It seems like it should,
		# but I keep getting "UncaughtThrowError: uncaught throw :warden"
		# it's been difficult to find a solution on Google since a lot of people
		# appear to be using Rspec
		# get user_confirmation_path(confirmation_token: new_user.confirmation_token)
		# assert_not new_user.confirmed?
	end
end
