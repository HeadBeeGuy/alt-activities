require 'test_helper'

class TextbooksControllerTest < ActionDispatch::IntegrationTest

  test "should get textbook index path" do
    get textbooks_path
    assert_response :success
  end

  test "should get specific textbook path" do
    get textbooks_path(:textbook_one)
    assert_response :success
  end
end
