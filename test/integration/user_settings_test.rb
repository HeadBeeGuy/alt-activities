require "test_helper"

class UserSettingsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @trusted = users(:trusted_user)
  end

	test "a user can successfully edit their information" do
		new_home_country = "Pottsylvania"
		new_location = "Frostbite Falls"
		new_bio = "I am not suspicious."
		sign_in(@regular_user_one)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		assert_match @regular_user_one.home_country, response.body
		get edit_user_path(@regular_user_one)
		patch user_path, params: { user: { home_country: new_home_country,
															location: new_location,
															bio: new_bio }}
		assert_redirected_to user_path(@regular_user_one)
		assert_not flash.empty?
		follow_redirect!
		get user_path(@regular_user_one)

		assert_match @regular_user_one.username, response.body
		assert_match new_home_country, response.body
		assert_match new_location, response.body
		assert_match new_bio, response.body
	end

  test "a user does not display their favorites until they specify so" do
		@activity = activities(:rebecca_activity)
		@upvote = upvotes(:upvote_two)

		assert @upvote.activity == @activity

		assert @regular_user_one.upvotes.include?(@upvote)
		assert_not @regular_user_one.display_favorites?
		get user_path(@regular_user_one)
		assert_no_match @activity.name, response.body

		sign_in @regular_user_one
		patch user_path, params: { user: { display_favorites: :true } }
		delete destroy_user_session_path

		@regular_user_one.reload
		assert @regular_user_one.display_favorites?
		get user_path(@regular_user_one)
		assert_match @activity.name, response.body

  end

end
