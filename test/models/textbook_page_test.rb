require 'test_helper'

class TextbookPageTest < ActiveSupport::TestCase

	def setup
		@textbook_page = textbook_pages(:textbook_page_one)
	end

	test "a textbook page with valid information should be valid" do
		assert @textbook_page.valid?
	end

	test "a textbook page must be associated with a textbook" do
		@textbook_page.textbook = nil
		assert_not @textbook_page.valid?
	end

	test "a textbook page must be associated with a tag" do
		@textbook_page.tag = nil
		assert_not @textbook_page.valid?
	end

	test "a textbook page must have a page" do
		@textbook_page.page = nil
		assert_not @textbook_page.valid?
	end

	test "a textbook page must be between 0 and 400" do
		@textbook_page.page = -1
		assert_not @textbook_page.valid?
		@textbook_page.page = 401
		assert_not @textbook_page.valid?
	end

	test "a textbook page's description can't be longer than 200 characters" do
		@textbook_page.description = "b" * 201
		assert_not @textbook_page.valid?
	end

end
