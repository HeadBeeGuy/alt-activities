require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @activity = activities(:basic_activity_one)
    @second_activity = activities(:basic_activity_two)
    @tagging = taggings(:tagging_one)
  end
  
  test "an activity with valid parameters is valid" do
    assert @activity.valid?
  end
  
  test "activities need to have a short name" do
    @activity.name = ""
    assert_not @activity.valid?
  end
  
  test "activities need to have a short description" do
    @activity.short_description = ""
    assert_not @activity.valid?
  end
  
  test "activities need to have a long description" do
    @activity.long_description = ""
    assert_not @activity.valid?
  end
  
  test "an activity's name can't be over 50 characters" do
    @activity.name = "a" * 51
    assert_not @activity.valid?
  end
  
  test "an activity's short description can't be over 200 characters" do
    @activity.short_description = "a" * 201
    assert_not @activity.valid?
  end
  
  test "an activity's long description can't be over 2000 characters" do
    @activity.long_description = "a" * 2001
    assert_not @activity.valid?
  end
  
  test "an activity must have some kind of tags" do
    # was previously testing to remove tags from an existing activity, but I think I should
    # try making a new activity without any tags
  end
end
