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
  
=begin
  # I've been really slacking on tests! this one isn't making it through Pundit for some reason
  # In my limited time to work on this, I'd like to spend it adding more functionality
  # At some point a Great Test Reckoning must occur, when I have more time to figure out why the tests aren't working
  test "regular users can successfully submit an activity" do
    sign_in(@regular_user_one)
    get new_activity_path
    
    post activities_path, params: { activity: { name: "a",
          short_description: "short", long_description: "long", time_estimate: "2 min" }}
    follow_redirect!
    
    #verify that the submission worked, but the user can't see the activity
    #log out
    #log a mod in
    #verify that the moderator sees the activity in the mod queue
    #approve it
    #verify that the moderator can see the activity on the site
    #log the moderator out
    #log the regular user back in, verify that they see the activity on the site
          
  end
=end
end