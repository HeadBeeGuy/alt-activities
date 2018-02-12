require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @activity = activities(:basic_activity)
    @second_activity = activities(:second_basic_activity)
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
  
end
