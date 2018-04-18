require 'test_helper'

class UpvoteActionTest < ActionDispatch::IntegrationTest
	include Devise::Test::IntegrationHelpers

	def setup
		@user = users(:regular_user_one)
		@activity = activities(:basic_activity_one)
	end

	test "an upvote with valid parameters is valid" do
		@upvote = upvotes(:upvote_one)
		assert @upvote.valid?
	end

	test "a user can upvote an activity and withdraw it without ajax" do
		sign_in(@user)
		get root_path
		get activity_path(@activity)
		assert_difference '@activity.upvote_count', 1 do
			post upvotes_path, params: { activity_id: @activity.id }
			@activity.reload # rather embarrassed at how long it took me to realize to do this!
		end
		assert_difference '@activity.upvote_count', -1 do
			delete upvote_path(@activity), params: { activity_id: @activity.id }
			@activity.reload 
		end
	end

	test "a user can upvote an activity and withdraw it with ajax" do
		sign_in(@user)
		get root_path
		get activity_path(@activity)
		assert_difference '@activity.upvote_count', 1 do
			post upvotes_path, xhr: true, params: { activity_id: @activity.id }
			@activity.reload
		end
		assert_difference '@activity.upvote_count', -1 do
			delete upvote_path(@activity), xhr: true, params: { activity_id: @activity.id }
			@activity.reload 
		end
	end

	test "a user can't upvote without being logged in" do
		get root_path
		get activity_path(@activity)
		assert_no_difference '@activity.upvote_count' do
			post upvotes_path, params: { activity_id: @activity.id }
			@activity.reload
		end
		# I had a test to show you can't withdraw an upvote too, but withdrawing downvotes
		# tosses out an error if a user isn't logged in
	end

	test "a user can't upvote an activity twice" do
		sign_in(@user)
		get root_path
		get activity_path(@activity)
		assert_difference '@activity.upvote_count', 1 do
			post upvotes_path, params: { activity_id: @activity.id }
			@activity.reload
		end

		assert_no_difference '@activity.upvote_count' do
			post upvotes_path, params: { activity_id: @activity.id }
			@activity.reload
		end
	end

end
