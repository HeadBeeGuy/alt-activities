require "test_helper"

class WorkshopTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @supporter = users(:trusted_user)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @supporter_activity = activities(:trusted_user_activity)
    @workshop_activity = activities(:workshop_activity)
  end

  test "an initial premium supporter user can workshop an activity" do
    assert @supporter.initial_premium?

    assert @supporter.activities.include? @supporter_activity
    assert_not @supporter_activity.workshop?

    sign_in @supporter
    get activity_path @supporter_activity
    put start_workshop_activity_path @supporter_activity
    
    @supporter_activity.reload
    assert @supporter_activity.workshop?

    put end_workshop_activity_path @supporter_activity
    @supporter_activity.reload
    assert_not @supporter_activity.workshop?
  end

  test "a regular user cannot change the workshop flag on another user's activity" do
    assert_not @regular_user_one.initial_premium?
    assert_not @regular_user_one.activities.include? @supporter_activity
    assert_not @supporter_activity.workshop?

    sign_in @regular_user_one
    get activity_path @supporter_activity
    put start_workshop_activity_path @supporter_activity
    @workshop_activity.reload
    assert_not @supporter_activity.workshop?

    assert @workshop_activity.workshop?
    assert_not @regular_user_one.activities.include? @workshop_activity

    get activity_path @workshop_activity
    put end_workshop_activity_path @workshop_activity
    @workshop_activity.reload
    assert @workshop_activity.workshop?
  end

  test "an initial premium user cannot change the workshop flag on another user's activity" do
    assert @supporter.initial_premium?
    assert_not @supporter.activities.include? @workshop_activity
    assert @workshop_activity.workshop?

    sign_in @supporter
    get activity_path @workshop_activity
    put end_workshop_activity_path @workshop_activity
    @workshop_activity.reload
    assert @workshop_activity.workshop?

    @non_workshop = activities(:basic_activity_one)
    assert_not @supporter.activities.include? @non_workshop
    assert_not @non_workshop.workshop?

    get activity_path @non_workshop
    put start_workshop_activity_path @non_workshop
    @non_workshop.reload
    assert_not @non_workshop.workshop?
  end
end
