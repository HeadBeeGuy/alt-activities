require 'test_helper'

class CommentFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @trusted = users(:trusted_user)
    @activity = activities(:basic_activity_one)
  end

  test "a comment can be successfully submitted to an activity on the site" do
    comment_text = "This activity rules! Well done!"

    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_difference('Comment.unapproved.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @activity.class, commentable_id: @activity.id }}
    end
    get activity_path(@activity)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_match comment_text, response.body
    assert_difference('Comment.normal.count', 1) do
      # this was Comment.last before, but it caused inconsistent test errors
      # let's hope they don't resurface!
      @new_comment = Comment.find_by_content(comment_text)
      put approve_comment_path(@new_comment)
    end
    get modqueue_path
    assert_no_match comment_text, response.body
    delete destroy_user_session_path
    
    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_match comment_text, response.body
  end

  test "comment functions work with ajax" do
    comment_text = "Reloading is for the birds! What is this, 2003?"
    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_difference('Comment.unapproved.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @activity.class, commentable_id: @activity.id }}, xhr: true
    end
    get activity_path(@activity)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_match comment_text, response.body
    assert_difference('Comment.normal.count', 1) do
      @new_comment = Comment.find_by_content(comment_text)
      put approve_comment_path(@new_comment), xhr: true
    end
    get modqueue_path
    assert_no_match comment_text, response.body
    delete destroy_user_session_path
    
    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_match comment_text, response.body
  end

  test "a silenced user cannot post comments" do
    comment_text = "Phooey and boo, says I!"

    sign_in @silenced
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_no_difference 'Comment.unapproved.count' do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @activity.class, commentable_id: @activity.id }}
    end
    get activity_path(@activity)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_no_match comment_text, response.body
  end

  test "a moderator can delete a comment in the mod queue" do
    comment_text = "Let me tell you about my breakfast this morning..."

    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @activity.name, response.body
    assert_difference('Comment.unapproved.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @activity.class, commentable_id: @activity.id }}
    end
    get activity_path(@activity)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_match comment_text, response.body
    assert_no_difference 'Comment.normal.count' do
      @new_comment = Comment.find_by_content(comment_text)
      delete comment_path(@new_comment)
    end
    get modqueue_path
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @regular_user_two
    get activity_path(@activity)
    assert_no_match comment_text, response.body
  end

  test "a user can delete one of their comments on an activity page" do
    @comment = comments(:comment_one) # written by the user in question
    comment_content = @comment.content # need to refer to it after it's deleted
    sign_in @regular_user_one
    get activity_path(@activity)
    assert_match comment_content, response.body
    assert_difference('Comment.normal.count', -1) do
      delete comment_path(@comment)
    end
    get activity_path(@activity)
    assert_no_match comment_content, response.body
  end

  test "a normal user can't delete another user's comments" do
    @comment = comments(:comment_one)
    sign_in @regular_user_two
    assert_not @comment.user == @regular_user_two
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert_no_difference 'Comment.normal.count' do
      delete comment_path(@comment)
    end
    get activity_path(@activity)
    assert_match @comment.content, response.body
  end

  test "a user can mark another user's comments as solved on their activity" do
    @comment = comments(:comment_two)
    assert @activity.user == @regular_user_one
    assert_not @comment.user == @regular_user_one
    sign_in @regular_user_one
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert @comment.normal?
    assert_difference('Comment.normal.count', -1) do
      put solve_comment_path(@comment)
    end
    @comment.reload
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert @comment.solved?
  end

  test "a normal user can't solve comments on another user's activities" do
    @comment = comments(:comment_one)
    assert_not @activity.user == @regular_user_two
    assert_not @comment.user == @regular_user_two
    sign_in @regular_user_two
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert @comment.normal?
    assert_no_difference 'Comment.normal.count' do
      put solve_comment_path(@comment)
    end
    @comment.reload
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert_not @comment.solved?
  end

  test "a moderator can pull a comment off a page and back into the mod queue" do
    @comment = comments(:comment_one)
    assert @comment.normal?
    sign_in(@moderator)
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert_difference('Comment.unapproved.count', 1) do
      put unapprove_comment_path(@comment)
    end
    get activity_path(@activity)
    assert_no_match @comment.content, response.body
    get modqueue_path
    assert_match @comment.content, response.body
    @comment.reload
    assert @comment.unapproved?
  end

  test "a normal user can't unapprove a comment" do
    @comment = comments(:comment_one)
    assert @comment.normal?
    sign_in(@regular_user_two)
    assert @regular_user_two.normal?
    get activity_path(@activity)
    assert_match @comment.content, response.body
    assert_no_difference 'Comment.unapproved.count' do
      put unapprove_comment_path(@comment)
    end
    get activity_path(@activity)
    assert_match @comment.content, response.body
    @comment.reload
    assert @comment.normal?
  end

  test "a comment can be successfully submitted to a front page post on the site" do
    comment_text = "Thanks for the update! I read every word!"
    @post = front_page_posts(:front_page_post_one)
    sign_in @regular_user_two
    get front_page_post_path(@post)
    assert_match @post.content, response.body
    assert_difference('Comment.unapproved.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @post.class, commentable_id: @post.id }}
    end
    get front_page_post_path(@post)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_match comment_text, response.body
    assert_difference('Comment.normal.count', 1) do
      @new_comment = Comment.find_by_content(comment_text)
      put approve_comment_path(@new_comment)
    end
    get modqueue_path
    assert_no_match comment_text, response.body
    get front_page_post_path(@post)
    assert_match @post.content, response.body
    assert_match comment_text, response.body
  end

  test "a comment can be successfully submitted to a tag on the site" do
    comment_text = "Call me what you will, but this tag just does it for me."
    @tag = tags(:basic_tag_one)
    sign_in @regular_user_two
    get tag_path(@tag)
    assert_match @tag.description, response.body
    assert_difference('Comment.unapproved.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @tag.class, commentable_id: @tag.id }}
    end
    get tag_path(@tag)
    assert_no_match comment_text, response.body
    delete destroy_user_session_path

    sign_in @moderator
    get modqueue_path
    assert_match comment_text, response.body
    assert_difference('Comment.normal.count', 1) do
      @new_comment = Comment.find_by_content(comment_text)
      put approve_comment_path(@new_comment)
    end
    get modqueue_path
    assert_no_match comment_text, response.body
    get tag_path(@tag)
    assert_match @tag.description, response.body
    assert_match comment_text, response.body
  end

  test "a trusted user can post a comment that is immediately visible" do
    comment_text = "Allow me to drop some knowledge."

    sign_in(@trusted)
    get activity_path(@activity)
    assert_difference('Comment.normal.count', 1) do
      post comments_path, params: { comment: { content: comment_text,
        commentable_type: @activity.class, commentable_id: @activity.id }}
    end
    assert_redirected_to @activity
    follow_redirect!
    assert_match comment_text, response.body
  end
end
