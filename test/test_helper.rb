ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'sidekiq/testing'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
	
	# tests were keeping jobs in the Sidekiq queue, which then leaked into the development environment	
	teardown do
		Sidekiq::Worker.clear_all
	end
end

# sounds like Devise tests don't work as well as they should in Rails 5
# adding this as per https://github.com/plataformatec/devise/issues/3913#issuecomment-174737364
class ActionDispatch::IntegrationTest
  def sign_in(user)
    post user_session_path \
      "user[email]"    => user.email,
      "user[password]" => user.password
  end
end
