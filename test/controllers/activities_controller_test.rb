require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get activities url" do
    get activities_path
    assert_response :success
  end
  
  test "should redirect activity creation url if not logged in" do
    get new_activity_path
    assert_redirected_to new_user_session_path
  end
end
