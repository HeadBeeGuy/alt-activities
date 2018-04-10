require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:regular_user_one)
		@second_user = users(:regular_user_two)
  end

  test "a user with valid information is valid" do
    assert @user.valid?
		assert @second_user.valid?
  end

  test "home country can't be longer than 30 characters" do
    @user.home_country = "a" * 31
    assert_not @user.valid?
  end  

	test "current location can't be longer than 30 characters" do
		@user.location = "a" * 31
		assert_not @user.valid?
	end

	test "bio can't be longer than 200 characters" do
		@user.bio = "a" * 201
		assert_not @user.valid?
	end

	test "e-mail must be present" do
		@user.email = ""
		assert_not @user.valid?
	end

	test "two users can't have the same e-mail address" do
		@second_user.email = @user.email
		assert_not @second_user.valid?		
	end
end
