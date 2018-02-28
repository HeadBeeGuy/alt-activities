require 'test_helper'

class TagCategoriesControllerTest < ActionDispatch::IntegrationTest
  # This was all automatically generated! I'll hafta go back and make this work later!
=begin
  setup do
    @tag_category = tag_categories(:one)
  end

  test "should get index" do
    get tag_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_tag_category_url
    assert_response :success
  end

  test "should create tag_category" do
    assert_difference('TagCategory.count') do
      post tag_categories_url, params: { tag_category: { name: @tag_category.name } }
    end

    assert_redirected_to tag_category_url(TagCategory.last)
  end

  test "should show tag_category" do
    get tag_category_url(@tag_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_tag_category_url(@tag_category)
    assert_response :success
  end

  test "should update tag_category" do
    patch tag_category_url(@tag_category), params: { tag_category: { name: @tag_category.name } }
    assert_redirected_to tag_category_url(@tag_category)
  end

  test "should destroy tag_category" do
    assert_difference('TagCategory.count', -1) do
      delete tag_category_url(@tag_category)
    end

    assert_redirected_to tag_categories_url
  end
=end
end
