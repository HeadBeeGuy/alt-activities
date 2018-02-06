require 'test_helper'

class SitePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get site_pages_home_url
    assert_response :success
  end

  test "should get about" do
    get site_pages_about_url
    assert_response :success
  end

end
