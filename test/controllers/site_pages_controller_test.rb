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

  test "should get elementary page" do
    get es_path
    assert_response :success
  end

  test "should get junior high page" do
    get jhs_path
    assert_response :success
  end

  test "should get grammar page" do
    get grammar_path
    assert_response :success
  end

  test "should get warm-ups page" do
    get warmups_path
    assert_response :success
  end

  test "should get the page that displays all tags" do
    get all_tags_path
    assert_response :success
  end

  test "should get high school page" do
    get hs_path
    assert_response :success
  end

  test "should get conversation page" do
    get conversation_path
    assert_response :success
  end

  test "should get online teaching page" do
    get online_teaching_path
    assert_response :success
  end
end
