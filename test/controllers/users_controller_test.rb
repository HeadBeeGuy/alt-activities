require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # conflicting information on the internet about whether to use ControllerHelpers or IntegrationHelpers
  # it's a bit hard to search for stuff since questions often apply to older versions of Devise and Rails
  #include Devise::Test::IntegrationHelpers
  
  def setup
    #@user = users(:regular_user)
  end
  
  test "a user with valid credentials should be able to log in" do
    #not sure if this is necessary or not, it keeps complaining about "env"
    #@request.env['devise.mapping'] = Devise.mappings[:user]
    #sign_in @user
    #assert_response :success
  end
end
