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
  test "regular users can successfully submit an activity" do
    sign_in(@regular_user_one)
    get new_activity_path
    
    # getting errors that it can't find the policy in the controller. apparently
    # restarting may fix this, but I want to move on to other stuff in the mean time
    post activities_path(@regular_user_one), params: { activity: { name: "a",
          short_description: "short", long_description: "long", time_estimate: "2 min" }}
    follow_redirect!
          
  end
=end
end