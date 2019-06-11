require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # the sign_in function isn't the one from Devise - it's a custom one in test_helper.rb
  
  def setup
    @user = users(:regular_user_one)
  end
  
  test "a user with valid credentials should be able to log in" do
    sign_in @user
    assert_response :success
  end

  test "should get user index page" do
    get users_path
    assert_redirected_to contributors_url
  end

  test "should get user page for a specific user" do
    get user_path(@user)
    assert_response :success
  end
end
