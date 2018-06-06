require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  
  test "should get activities url" do
    get activities_path
    assert_response :success
  end

  test "should get activity path for a specific activity" do
    get activities_path(:basic_activity_one)
    assert_response :success
  end
  
  test "should redirect activity creation url if not logged in" do
    get new_activity_path
    assert_redirected_to new_user_session_path
  end
end
