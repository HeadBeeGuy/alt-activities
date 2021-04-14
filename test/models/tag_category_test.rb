require 'test_helper'

class TagCategoryTest < ActiveSupport::TestCase
  
  def setup
    @tag_category = tag_categories(:tag_category_one)
  end

  test "a tag category with valid information is valid" do
    assert @tag_category.valid?
  end
  
  test "tag category names can't be blank" do
    @tag_category.name = ""
    assert_not @tag_category.valid?
  end
  
  test "tag category name can't be over 50 characters" do
    @tag_category.name = "a" * 51
    assert_not @tag_category.valid?
  end

  test "tag category instruction can't be over 500 characters" do
    @tag_category.instruction = "i" * 501
    assert_not @tag_category.valid?
  end

  test "tag category suggested max must be between 0 and 20" do
    @tag_category.suggested_max = -1
    assert_not @tag_category.valid?
    @tag_category.suggested_max = 21
    assert_not @tag_category.valid?
  end
end
