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
  

  test "regular users can successfully submit an activity" do
    sign_in(@regular_user_one)
    get new_activity_path
    activity_name = "My test activity"
    # Passing tag_ids with direct values in an Array seems like a bad idea, but I haven't figured out
    # how to add them in as references to the tag fixtures yet
    post activities_path, params: { activity: { name: activity_name,
          short_description: "short", long_description: "long", time_estimate: "2 min", 
          tag_ids: [1, 2] }}
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
    
    #approve it - how do I tell it to go to that particular activity?
    
    # at this point I really need to finish the test, but I need to deploy to fix a bug I introduced
    
    #verify that the moderator can see the activity on the site
    #log the moderator out
    #log the regular user back in, verify that they see the activity on the site
          
  end

end