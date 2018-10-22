require 'test_helper'

class TaggingsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @activity = activities(:basic_activity_one)
    @tag_one = tags(:basic_tag_one)
    @tag_two = tags(:basic_tag_two)
    @tag_three = tags(:basic_tag_three)
  end

  test "a user can add and remove a tag to their activity using ajax" do
    assert_not @activity.tags.include? @tag_three
    assert @regular_user_one.activities.include? @activity

    sign_in @regular_user_one
    get activity_path(@activity)
    assert_difference 'Tagging.count', 1 do
      post taggings_path, params: { tagging: { activity_id: @activity.id,
                                               tag_id: @tag_three.id }}, xhr: true                                               
    end
    assert @activity.tags.include? @tag_three
    get activity_path(@activity)
    @new_tagging = @activity.taggings.find_by_tag_id(@tag_three.id)
    assert_difference 'Tagging.count', -1 do
      delete tagging_path(@new_tagging), xhr: true
    end
    assert_not @activity.tags.include? @tag_three
  end

  test "a user can add and remove a tag to their activity without ajax" do
    assert_not @activity.tags.include? @tag_three
    assert @regular_user_one.activities.include? @activity

    sign_in @regular_user_one
    get activity_path(@activity)
    assert_difference 'Tagging.count', 1 do
      post taggings_path, params: { tagging: { activity_id: @activity.id,
                                               tag_id: @tag_three.id }}
    end
    assert @activity.tags.include? @tag_three
    get activity_path(@activity)
    @new_tagging = @activity.taggings.find_by_tag_id(@tag_three.id)
    assert_difference 'Tagging.count', -1 do
      delete tagging_path(@new_tagging)
    end
    assert_not @activity.tags.include? @tag_three
  end

  test "an admin or moderator can add or delete tags on an activity they didn't create" do
    assert_not @admin.activities.include? @activity
    assert_not @activity.tags.include? @tag_two
    sign_in @admin
    assert_difference 'Tagging.count', 1 do
      post taggings_path, params: { tagging: { activity_id: @activity.id,
                                               tag_id: @tag_two.id }}, xhr: true                                               
    end
    assert @activity.tags.include? @tag_two
    get activity_path(@activity)
    @new_tagging = @activity.taggings.find_by_tag_id(@tag_two.id)
    assert_difference 'Tagging.count', -1 do
      delete tagging_path(@new_tagging), xhr: true
    end
    assert_not @activity.tags.include? @tag_two
    delete destroy_user_session_path

    assert_not @moderator.activities.include? @activity
    assert_not @activity.tags.include? @tag_three
    sign_in @moderator
    assert_difference 'Tagging.count', 1 do
      post taggings_path, params: { tagging: { activity_id: @activity.id,
                                               tag_id: @tag_three.id }}, xhr: true                                               
    end
    assert @activity.tags.include? @tag_three
    get activity_path(@activity)
    @new_tagging = @activity.taggings.find_by_tag_id(@tag_three.id)
    assert_difference 'Tagging.count', -1 do
      delete tagging_path(@new_tagging), xhr: true
    end
    assert_not @activity.tags.include? @tag_three
  end

  test "a normal user can't edit another user's tags" do
    assert_not @regular_user_two.activities.include? @activity
    assert_not @activity.tags.include? @tag_two

    sign_in @regular_user_two
    get activity_path(@activity)
    assert_no_difference 'Tagging.count' do
      post taggings_path, params: { tagging: { activity_id: @activity.id,
                                               tag_id: @tag_two.id }}
    end
    assert_not @activity.tags.include? @tag_two

    assert @activity.tags.include? @tag_one
    assert_no_difference 'Tagging.count' do
      delete tagging_path( @activity.taggings.find_by_tag_id(@tag_one.id) )
    end
    assert @activity.tags.include? @tag_one
  end

end
