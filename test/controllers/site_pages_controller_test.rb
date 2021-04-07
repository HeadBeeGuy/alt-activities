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

  test "should get high school page" do
    get hs_path
    assert_response :success
  end

  test "should get online teaching page" do
    get online_teaching_path
    assert_response :success
  end

  test "should get special needs page" do
    get special_needs_path
    assert_response :success
  end

  test "should get contact page" do
    get contact_path
    assert_response :success
  end

  test "should get resources page" do
    get resources_path
    assert_response :success
  end

  test "should get contributors page" do
    get contributors_path
    assert_response :success
  end
end
