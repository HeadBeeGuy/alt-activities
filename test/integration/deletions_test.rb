require 'test_helper'

class DeletionsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user = users(:regular_user_one)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @activity = activities(:basic_activity_one)
  end

  test "deleting a user deletes their activities, upvotes, and comments" do
    @another_activity = activities(:rebecca_activity)
    @tag = tags(:basic_tag_one)
    @comment = comments(:comment_three)
    comment_content = @comment.content
    activity_name = @activity.name
    assert @regular_user.valid?
    assert @regular_user.activities.include? @activity

    # asserting that the user has made an upvote
    # there's probably a more elegant way to write this
    assert Upvote.where(activity: @another_activity,
                        user: @regular_user).any?
    assert @activity.tags.include? @tag
    get tag_path @tag
    assert_match @tag.name, response.body
    assert_match activity_name, response.body

    get activity_path @another_activity
    assert_match comment_content, response.body

    sign_in @admin
    get user_path @regular_user
    assert_difference 'Upvote.count', -1 do
      delete user_path @regular_user
    end

    get tag_path @tag
    assert_no_match activity_name, response.body
    get activity_path @another_activity
    assert_no_match comment_content, response.body    
  end
 
end
