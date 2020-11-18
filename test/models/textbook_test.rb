require 'test_helper'

class TextbookTest < ActiveSupport::TestCase

	def setup
		@textbook = textbooks(:textbook_one)
	end

	test "a textbook with valid parameters is valid" do
		assert @textbook.valid?
	end

	test "textbooks need to have a name" do
		@textbook.name = ""
		assert_not @textbook.valid?
	end

	test "textbook names can't be over 50 characters" do
		@textbook.name = "a" * 51
		assert_not @textbook.valid?
	end

	test "textbook info can't be over 250 characters" do
		@textbook.additional_info = "a" * 251
		assert_not @textbook.valid?
	end

  test "textbooks can have a nil value for its published year" do
    @textbook.year_published = nil
    assert @textbook.valid?
  end

  test "textbooks with a published year must be between 1900 and 2100" do
    @textbook.year_published = 1900
    assert_not @textbook.valid?
    @textbook.year_published = 2100
    assert_not @textbook.valid?
  end
end

