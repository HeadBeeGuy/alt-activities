require 'test_helper'

class ActivityLinksControllerTest < ActionDispatch::IntegrationTest
  test "should get textbook page link index url" do
    get textbook_page_links_path
    assert_response :success
  end
end
