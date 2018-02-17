require 'test_helper'

class SitePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_path
    assert_response :success
  end

end
