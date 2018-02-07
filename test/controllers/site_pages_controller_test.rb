require 'test_helper'

class SitePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    # will the site always have a root_url by default? oh well, let's test anyway!
    get root_url
    assert_response :success
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

end
