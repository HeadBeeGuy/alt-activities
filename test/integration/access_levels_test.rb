require 'test_helper'

# maybe there's a better convention to naming this test or a more appropriate test to file these into
class AccessLevelsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
  end
  
  test "creating new activities should redirect when not logged in" do
    get new_activity_path
    assert_redirected_to new_user_session_path
  end
  
  test "normal users and users not logged in cannot access the mod queue" do
    get modqueue_path
    assert_redirected_to new_user_session_path
    assert_not flash.empty?
    sign_in(@regular_user_one)
    get modqueue_path
    assert_redirected_to root_url
    assert_not flash.empty?
  end
  
  test "silenced users cannot create an activity" do
    @tag = tags(:basic_tag_one)
    activity_name = "My salacious activity"
    sign_in(@silenced)
    get new_activity_path
    assert_redirected_to root_url
    assert_not flash.empty?
    #gonna be real stubborn and post an activity directly!
    assert_no_difference 'Activity.count' do
      post activities_path, params: { activity: { name: activity_name,
            short_description: "short", long_description: "long", time_estimate: "5 min", 
            tag_ids: [@tag.id] }}
    end
    get tag_path(tags(:basic_tag_one))
    assert_no_match activity_name, response.body
  end
  
  test "moderators can see the mod queue" do
    sign_in(@moderator)
    get modqueue_path
    assert_response :success
  end

  # this won't work in tag_test.rb! Do I have to do this in integration tests?
  test 'tags can be deleted by admins' do
    @tag = tags(:basic_tag_one)
    sign_in(@admin)
    get all_tags_path # for some reason I have to access another page before I do the next get request
    get tag_path(@tag)
    assert_match @tag.long_name, response.body
    assert_difference('Tag.count', -1) do
      delete tag_path(@tag)
    end
    get all_tags_path
    assert_no_match @tag.long_name, response.body
  end
  
  test 'non-admins cannot delete tags' do
    @tag = tags(:basic_tag_one)
    sign_in(@moderator)
    get all_tags_path
    get tag_path(@tag)
    assert_match @tag.long_name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get all_tags_path
    assert_match @tag.long_name, response.body
    delete destroy_user_session_path
    
    sign_in(@regular_user_one)
    get all_tags_path
    get tag_path(@tag)
    assert_match @tag.long_name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get all_tags_path
    assert_match @tag.long_name, response.body
    delete destroy_user_session_path
    
    sign_in(@silenced)
    get all_tags_path
    get tag_path(@tag)
    assert_match @tag.long_name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get all_tags_path
    assert_match @tag.long_name, response.body
    delete destroy_user_session_path
  end
  
  # future tests:
  # a normal user cannot edit another user's activity
end