require 'test_helper'

class FrontPagePostTest < ActiveSupport::TestCase

	def setup
		@post = front_page_posts(:front_page_post_one)
	end
	
	test "a front page post's title must be present" do
		@post.title = ""
		assert_not @post.valid?
	end

	test "a front page post's title can't be over 250 characters" do
		@post.title = "a" * 251
		assert_not @post.valid?
	end

	test "a front page post's excerpt can't be over 1000 characters" do
		@post.excerpt = "a" * 1001
		assert_not @post.valid?
	end

	test "a front page post's content must be present" do
		@post.content = ""
		assert_not @post.valid?
	end

	test "a front page post's content can't be over 15000 characters" do
		@post.content = "a" * 15001
		assert_not @post.valid?
	end
end
