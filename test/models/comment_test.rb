require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = comments(:comment_one)
  end

  test "a comment can't be blank" do
    @comment.content = ""
    assert_not @comment.valid?
  end

  test "a comment can't be over 500 characters" do
    @comment.content = "a" * 501
    assert_not @comment.valid?
  end
end
