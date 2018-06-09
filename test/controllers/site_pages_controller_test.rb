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

	test "should get ALTTO page" do
		get altto_path
		assert_response :success
	end

end
