require 'test_helper'

class TextbooksAndTextbookPagesFlowTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

	def setup
    @regular_user = users(:regular_user_one)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
		@textbook = textbooks(:textbook_one)
		@textbook_page = textbook_pages(:textbook_page_one)
  end

	test "moderators can successfully create a textbook" do
		sign_in(@moderator)
		get textbooks_path
		textbook_name = "They made another textbook!"
		get new_textbook_path
		assert_difference("Textbook.count", 1) do
			post textbooks_path, params: { textbook: { name: textbook_name,
						additional_info: "The contents will shock and delight you!",
						level: :JHS, year_published: 2010 } }
		end
		get textbooks_path
		assert_match textbook_name, response.body
	end

	test "normal and silenced users cannot create textbooks" do
		sign_in(@regular_user)
		get textbooks_path
		textbook_name = "My unauthorized textbook"
		get new_textbook_path
		assert_no_difference "Textbook.count" do
			post textbooks_path, params: { textbook: { name: textbook_name,
						additional_info: "The contents will shock and delight you!",
						level: :JHS, year_published: 2009 } }
		end
		get textbooks_path
		assert_no_match textbook_name, response.body
    delete destroy_user_session_path

		sign_in(@silenced)
		get textbooks_path
		get new_textbook_path
		assert_no_difference "Textbook.count" do
			post textbooks_path, params: { textbook: { name: textbook_name,
						additional_info: "The contents will shock and delight you!",
						level: :JHS, year_published: 2008} }
		end
		get textbooks_path
		assert_no_match textbook_name, response.body
	end

	# still need to implement: edits (both), deletion (both), confirming normal/silenced users can't do either
	# and creation for textbook pages
end
