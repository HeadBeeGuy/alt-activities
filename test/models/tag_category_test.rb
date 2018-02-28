require 'test_helper'

class TagCategoryTest < ActiveSupport::TestCase
  
  def setup
    @tag_category = tag_categories(:tag_category_one)
  end
  
  test "tag category names can't be blank" do
    @tag_category.name = ""
    assert_not @tag_category.valid?
  end
  
  test "tag category name can't be over 50 characters" do
    @tag_category.name = "a" * 51
    assert_not @tag_category.valid?
  end
end
