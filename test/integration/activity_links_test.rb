require 'test_helper'

class ActivityLinksTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:regular_user_two)
    @moderator = users(:moderator_user_one)
    @admin = users(:admin_user_one)
    @inspired_activity = activities(:derivative_activity_one)
    @original_activity = activities(:influential_activity)
    @someone_elses_activity = activities(:basic_activity_one)
  end

  test "a user can successfully create an activity link on one of their activities" do
    sign_in @user
    assert @user.activities.include? @inspired_activity
    get activity_path(@inspired_activity)
    assert_no_match @original_activity, response.body
    assert_difference('ActivityLink.count', 1) do
      post activity_links_path, xhr: true, params: { activity_link: 
        { id: @original_activity.id }, inspired_id: @inspired_activity.id } 
    end
    get activity_path(@inspired_activity)
    assert_match @original_activity.name, response.body
  end

  test "a normal user cannot add activity links to activities they do not own" do
    assert @user.normal?
    sign_in @user
    assert_not @user.activities.include? @someone_elses_activity
    get activity_path(@someone_elses_activity)
    assert_no_match @original_activity.name, response.body
    assert_no_difference 'ActivityLink.count' do
      post activity_links_path, xhr: true, params: { activity_link: 
        { id: @original_activity.id }, inspired_id: @someone_elses_activity.id } 
    end
  end
  
  test "a moderator can link two activities even if they don't own either of them" do
    sign_in @moderator
    assert_not @moderator.activities.include? @inspired_activity
    assert_not @moderator.activities.include? @original_activity
    get activity_path(@inspired_activity)
    assert_no_match @original_activity, response.body
    assert_difference('ActivityLink.count', 1) do
      post activity_links_path, xhr: true, params: { activity_link: 
        { id: @original_activity.id }, inspired_id: @inspired_activity.id } 
    end
    get activity_path(@inspired_activity)
    assert_match @original_activity.name, response.body
  end

  test "an admin can link two activities even if they don't own either of them" do
    sign_in @admin
    assert_not @admin.activities.include? @inspired_activity
    assert_not @admin.activities.include? @original_activity
    get activity_path(@inspired_activity)
    assert_no_match @original_activity, response.body
    assert_difference('ActivityLink.count', 1) do
      post activity_links_path, xhr: true, params: { activity_link: 
        { id: @original_activity.id }, inspired_id: @inspired_activity.id } 
    end
    get activity_path(@inspired_activity)
    assert_match @original_activity.name, response.body
  end
end
