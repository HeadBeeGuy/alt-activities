require "test_helper"

class TextbookPageLinksTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:regular_user_one)
    @unlinked_activity = activities(:roger_activity)
    @unlinked_page = textbook_pages(:textbook_page_one)
  end

  test "a user can successfully link an activity to a textbook page" do
    sign_in @user
    assert_not @unlinked_page.linked_activities.include? @unlinked_activity
    assert @user.activities.include? @unlinked_activity
    get root_url

    get textbook_page_path @unlinked_page
    assert_difference 'TextbookPageLink.count', 1 do
      post textbook_page_links_path, params: { textbook_page_link:
        { activity_id: @unlinked_activity.id, textbook_page_id: @unlinked_page.id } }
    end

    get textbook_page_path @unlinked_page
    assert_match @unlinked_activity.name, response.body
  end

  test "a regular user can't link another user's activity to a textbook page" do
    @other_activity = activities(:rebecca_activity)
    assert_not @user.activities.include? @other_activity
    assert_not @other_activity.linked_pages.include? @unlinked_page

    sign_in @user
    get textbook_page_path @unlinked_page
    assert_no_difference 'TextbookPageLink.count' do
      post textbook_page_links_path, params: { textbook_page_link:
        { activity_id: @other_activity.id, textbook_page_id: @unlinked_page.id } }
    end
  end

  test "a regular user can delete a textbook page link on their activity" do
    @textbook_page = textbook_pages(:textbook_page_one)
    @activity = activities(:basic_activity_one)
    @textbook_page_link = TextbookPageLink.where(activity_id: @activity.id,
                                                 textbook_page_id: @textbook_page.id).first

    assert @user.activities.include? @activity
    assert @textbook_page.linked_activities.include? @activity
    sign_in @user

    get activity_path @activity
    assert_difference 'TextbookPageLink.count', -1 do
      delete textbook_page_link_path @textbook_page_link
    end
  end

  test "a regular user can't delete textbook page links on activites they don't own" do
    @other_activity = activities(:rebecca_activity)
    @page_two = textbook_pages(:textbook_page_two)
    @textbook_page_link = TextbookPageLink.where(activity_id: @other_activity.id,
                                                 textbook_page_id: @page_two.id).first

    assert_not @user.activities.include? @other_activity
    assert @page_two.linked_activities.include? @other_activity

    sign_in @user
    get activity_path @other_activity

    assert_no_difference 'TextbookPageLink.count' do
      delete textbook_page_link_path @textbook_page_link
    end
  end
end
