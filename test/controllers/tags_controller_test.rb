require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest

  test "should get tags path" do
    get tags_path
    assert_response :success
  end

  test "should get tag path for a specific tag" do
    get tags_path(:basic_tag_one)
    assert_response :success
  end
end
