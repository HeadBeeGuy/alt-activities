require 'test_helper'


class AccessLevelsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
  end
  
  test "regular users can successfully submit an activity" do
    @tag = tags(:basic_tag_one)
    sign_in(@regular_user_one)
    
    get new_activity_path
    activity_name = "My test activity"
    assert_difference('Activity.unapproved.count', 1) do
      # is there a way I can pass the tag ids by their fixture names? haven't been able to figure that out yet
      post activities_path, params: { activity: { name: activity_name,
            short_description: "short", long_description: "long", time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end
    
    follow_redirect!
    assert_not flash.empty?
    
    #the easiest way to check if the activity isn't there would be to look for it in activities_path
    #but as the site grows, it would be unfeasible to have all activities on one page
    #the tag fixture may not correspond to what I passed in when I created the activity
    get tag_path(tags(:basic_tag_one))
    assert_no_match activity_name, response.body
    delete destroy_user_session_path
    
    
    sign_in(@moderator)
    get modqueue_path
    assert_match activity_name, response.body
    
    # this seems like this isn't a great way to do this, but without Capybara I don't think I can tell minitest to click on links 
    get activity_path(Activity.find_by_name(activity_name))
    assert_match activity_name, response.body
    
    put approve_activity_path(Activity.find_by_name(activity_name))
    follow_redirect!
    # since the admin is redirected back to the modqueue, the activity shouldn't be there anymore
    assert_no_match activity_name, response.body
    
    get tag_path(tags(:basic_tag_one))
    assert_match activity_name, response.body
    delete destroy_user_session_path
    
    
    sign_in(@regular_user_one)
    get tag_path(tags(:basic_tag_one))
    assert_match activity_name, response.body
          
  end
  
  test "regular users can edit an activity" do
		@existing_activity = activities(:basic_activity_one)
		@tag = tags(:basic_tag_one)
		sign_in(@regular_user_one)
		get root_path
		get activity_path(@existing_activity)
		assert_match @existing_activity.name, response.body
    #submit an edit
		edited_short = "My new short description"
		edited_long = "My new long description"
		get edit_activity_path(@existing_activity)
    assert_difference('Activity.approved.count', -1) do
			patch activity_path, params: { activity: { name: @existing_activity.name,
            short_description: edited_short, long_description: edited_long, time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end 
		#verify that the activity is no longer visible
		get tag_path(@tag)
		assert_no_match @existing_activity.name, response.body
    delete destroy_user_session_path

		sign_in(@moderator)
    get modqueue_path
    assert_match @existing_activity.name, response.body
    
		get activity_path(Activity.find_by_name(@existing_activity.name))
    assert_match @existing_activity.name, response.body
    
    put approve_activity_path(Activity.find_by_name(@existing_activity.name))
    follow_redirect!
    # since the admin is redirected back to the modqueue, the activity shouldn't be there anymore
    assert_no_match @existing_activity.name, response.body
    
    get tag_path(@tag)
    assert_match @existing_activity.name, response.body
    delete destroy_user_session_path

		sign_in(@regular_user_one)
		get root_path
		get tag_path(@tag)
		assert_match @existing_activity.name, response.body
		get activity_path(@existing_activity)
		assert_match edited_short, response.body
		assert_match edited_long, response.body
  end
end
