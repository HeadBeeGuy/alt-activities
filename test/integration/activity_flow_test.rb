require 'test_helper'


class AccessLevelsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @trusted = users(:trusted_user)
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

    @new_activity = @regular_user_one.activities.last
    assert_redirected_to @new_activity
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
    
    get activity_path(@new_activity)
    assert_match activity_name, response.body
    
    put approve_activity_path(@new_activity)
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
    assert @existing_activity.approved?
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
    assert_redirected_to @existing_activity
		#verify that the activity is no longer visible in listings
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

  test "editing an unapproved activity preserves its unapproved status until a moderator approves it" do
    @tag = tags(:basic_tag_one)
    sign_in(@regular_user_one)
    
    get new_activity_path
    activity_name = "I like to edit this activity"
    assert_difference('Activity.unapproved.count', 1) do
      # is there a way I can pass the tag ids by their fixture names? haven't been able to figure that out yet
      post activities_path, params: { activity: { name: activity_name,
            short_description: "short", long_description: "long", time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end

    @new_activity = @regular_user_one.activities.last
    assert_redirected_to @new_activity
    assert @new_activity.unapproved?
    
    get edit_activity_path(@new_activity)
    assert_no_difference('Activity.approved.count') do
			patch activity_path, params: { activity: { name: @new_activity.name,
            short_description: "edited!", long_description: "edited!", time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end 
    assert_redirected_to @new_activity
    assert @new_activity.unapproved?
  end

  test "a trusted user can edit an activity and it will remain visible" do
    @trusted_activity = activities(:trusted_user_activity)
    @tag = tags(:basic_tag_one)
    sign_in(@trusted)
    assert @trusted_activity.approved?
    assert @trusted.trusted?

    new_name = "I edit with impunity!"

    get tags_path(@tag)
    assert_match @tag.name, response.body

    get edit_activity_path(@trusted_activity)
    assert_no_difference('Activity.approved.count') do
			patch activity_path, params: { activity: { name: new_name,
            short_description: "edited!", long_description: "edited!", time_estimate: "2 min"}}
    end 
    # asserting a redirect causes an issue because the URL slug changes with the name
    get activity_path(@trusted_activity)
    assert_match new_name, response.body
    delete destroy_user_session_path

    @trusted_activity.reload

    get activities_path(@trusted_activity)
    assert_match new_name, response.body

    sign_in(@moderator)
    get modqueue_path
    assert_match new_name, response.body
    assert_not @trusted_activity.checked?
    get activity_path(@trusted_activity)
    put verify_edits_activity_path(@trusted_activity)

    @trusted_activity.reload
    assert @trusted_activity.checked?
    delete destroy_user_session_path

    get tags_path(@tag)
    assert_match @tag.name, response.body
  end

  test "a trusted but non-moderator user cannot approve their own edits" do
    @trusted_activity = activities(:trusted_user_activity)
    @tag = tags(:basic_tag_one)
    sign_in(@trusted)
    assert @trusted.trusted?
    assert @trusted_activity.checked?

    new_name = "Getting carried away here!"

    get activities_path(@trusted_activity)
    assert_match @trusted_activity.name, response.body

    get edit_activity_path(@trusted_activity)
    patch activity_path, params: { activity: { name: new_name,
          short_description: "edited!", long_description: "edited!", time_estimate: "2 min"}}
    get activity_path(@trusted_activity)
    assert_match new_name, response.body

    @trusted_activity.reload
    assert_not @trusted_activity.checked?
  end

  test "trusted users can submit activities which are visible right away" do
    @tag = tags(:basic_tag_one)
    sign_in(@trusted)
    
    get new_activity_path
    activity_name = "Another sweet activity of mine"
    assert_difference('Activity.count', 1) do
      post activities_path, params: { activity: { name: activity_name,
            short_description: "short", long_description: "long", time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end

    @new_activity = @trusted.activities.last
    assert_redirected_to @new_activity
    assert_not flash.empty?
    follow_redirect!

    assert_not @new_activity.checked?
    
    get tag_path(@tag)
    assert_match activity_name, response.body
    delete destroy_user_session_path
    
    
    sign_in(@moderator)
    get modqueue_path
    assert_match activity_name, response.body
    
    put verify_edits_activity_path(@new_activity)
    follow_redirect!
    assert_no_match activity_name, response.body
    
    @new_activity.reload
    assert @new_activity.checked?

    delete destroy_user_session_path
    get tag_path(@tag)
    assert_match activity_name, response.body
  end
end
