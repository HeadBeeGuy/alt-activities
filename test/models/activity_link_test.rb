require 'test_helper'

class ActivityLinkTest < ActiveSupport::TestCase
  def setup
    @original = activities(:basic_activity_one)
    @derivative = activities(:basic_activity_two)
    @link = ActivityLink.new(original_id: @original.id, inspired_id: @derivative.id,
                            explanation: "Same activity, but much better!")
  end

  test "an activity link with valid data is valid" do
    assert @link.valid?
  end

  test "an activity can be linked and unlinked with another one" do
    assert_not @original.inspired_activities.include? @derivative
    assert_not @derivative.source_activities.include? @original
    @derivative.add_inspired_by(@original)
    assert @original.inspired_activities.include? @derivative
    assert @derivative.source_activities.include? @original
    @derivative.remove_inspired_by(@original)
    assert_not @original.inspired_activities.include? @derivative
    assert_not @derivative.source_activities.include? @original
  end


end
