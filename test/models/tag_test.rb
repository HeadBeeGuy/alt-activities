require 'test_helper'

class TagTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  
  def setup
    @tag = tags(:basic_tag_one)
    @regular_user_one = users(:regular_user_one)
    @admin = users(:admin_user_one)
  end
  
  test "a tag with valid parameters is valid" do
    assert @tag.valid?
  end
  
  test "tags need to have a description" do
    @tag.description = ""
    assert_not @tag.valid?
  end
  
  test "a tag's name cannot be over 50 characters" do
    @tag.name = "a" * 51
    assert_not @tag.valid?
  end
  
  test "a tag's description cannot be over 100 characters" do
    @tag.description = "a" * 101
    assert_not @tag.valid?
  end
  
end
