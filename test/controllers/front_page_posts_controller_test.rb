require 'test_helper'

class FrontPagePostsControllerTest < ActionDispatch::IntegrationTest
  test "should get front page posts url" do
    get front_page_posts_path
    assert_response :success
  end

  test "should get front page post path for a specific post" do
    get front_page_posts_path(:front_page_post_one)
    assert_response :success
  end
end
