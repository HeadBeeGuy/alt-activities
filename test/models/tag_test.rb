require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = tags(:basic_tag_one)
  end
  
  test "a tag with valid parameters is valid" do
    assert @tag.valid?
  end
  
  test "tags need to have a short name" do
    @tag.short_name = ""
    assert_not @tag.valid?
  end
  
  test "tags need to have a long name" do
    @tag.long_name = ""
    assert_not @tag.valid?
  end
  
  test "tags need to have a description" do
    @tag.description = ""
    assert_not @tag.valid?
  end
  
  test "a tag's short name cannot be over 20 characters" do
    @tag.short_name = "a" * 21
    assert_not @tag.valid?
  end
  
  test "a tag's long name cannot be over 30 characters" do
    @tag.long_name = "a" * 31
    assert_not @tag.valid?
  end
  
  test "a tag's description cannot be over 100 characters" do
    @tag.description = "a" * 101
    assert_not @tag.valid?
  end
  
end
