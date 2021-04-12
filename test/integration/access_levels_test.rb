require 'test_helper'

# maybe there's a better convention to naming this test or a more appropriate test to file these into
class AccessLevelsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  def setup
    @regular_user_one = users(:regular_user_one)
    @regular_user_two = users(:regular_user_two)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @trusted = users(:trusted_user)
    #@tag = tags(:basic_tag_one) # I had this in several tests, then tried to put it up here, but it broke tests! wha??
  end
  
  test "creating new activities should redirect when not logged in" do
    get new_activity_path
    assert_redirected_to new_user_session_path
		assert_not flash.empty?
  end
  
  test "normal users and users not logged in cannot access the mod queue" do
    get modqueue_path
    assert_redirected_to root_url
    assert_not flash.empty?
    sign_in(@regular_user_one)
    get modqueue_path
    assert_redirected_to root_url
    assert_not flash.empty?
  end
  
  test "silenced users cannot create an activity" do
    @tag = tags(:basic_tag_one)
    activity_name = "My salacious activity"
    sign_in(@silenced)
    get new_activity_path
    assert_redirected_to root_url
    assert_not flash.empty?
    #gonna be real stubborn and post an activity directly!
    assert_no_difference 'Activity.count' do
      post activities_path, params: { activity: { name: activity_name,
            short_description: "short", long_description: "long", time_estimate: "5 min", 
            tag_ids: [@tag.id] }}
    end
    get tag_path(tags(:basic_tag_one))
    assert_no_match activity_name, response.body
  end
  
  test "moderators and admins can see the mod queue" do
    sign_in(@moderator)
    get modqueue_path
    assert_response :success
    delete destroy_user_session_path
		sign_in(@admin)
    get modqueue_path
    assert_response :success
  end

  test 'tags can be deleted by admins' do
    @tag = tags(:basic_tag_one)
    sign_in(@admin)
    get tags_path # for some reason I have to access another page before I do the next get request
    get tag_path(@tag)
    assert_match @tag.name, response.body
    assert_difference('Tag.count', -1) do
      delete tag_path(@tag)
    end
    get tags_path
    assert_no_match @tag.name, response.body
  end
  
  test 'non-admins cannot delete tags' do
    @tag = tags(:basic_tag_one)
    sign_in(@moderator)
    get tags_path
    get tag_path(@tag)
    assert_match @tag.name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get tags_path
    assert_match @tag.name, response.body
    delete destroy_user_session_path
    
    sign_in(@regular_user_one)
    get tags_path
    get tag_path(@tag)
    assert_match @tag.name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get tags_path
    assert_match @tag.name, response.body
    delete destroy_user_session_path
    
    sign_in(@silenced)
    get tags_path
    get tag_path(@tag)
    assert_match @tag.name, response.body
    assert_no_difference 'Tag.count' do
      delete tag_path(@tag)
    end
    get tags_path
    assert_match @tag.name, response.body
    delete destroy_user_session_path
  end
  
  test "a normal user cannot edit another user's activity" do
    @tag = tags(:basic_tag_one)
		@not_my_activity = activities(:rebecca_activity)
		sign_in(@regular_user_one)
		get root_path
		get activity_path(@not_my_activity)
		get edit_activity_path(@not_my_activity)
		assert_not flash.empty?
		assert_redirected_to root_url 

		#stubbornly attempt to patch an activity directly
		hacked_description = "U got hacked!!!"
		assert_no_difference('Activity.edited.count', -1) do
			patch activity_path, params: { activity: { name: "I hacked this activity!",
            short_description: hacked_description, long_description: "long", time_estimate: "2 min", 
            tag_ids: [@tag.id] }}
    end 
		follow_redirect!
		get activity_path(@not_my_activity)
		assert_no_match hacked_description, response.body # I would check for the title, but the apostrophe throws it off
	end

	test "admins can edit tags" do
    @tag = tags(:basic_tag_one)
		sign_in(@admin)
		get root_path
		get tag_path(@tag.id)
		new_name = "The Edited Tag"
		get edit_tag_path(@tag)
		patch tag_path, params: { tag: { name: new_name, description: @tag.description, 
                                   tag_category_id: @tag.tag_category.id }}
		get tag_path(@tag)
		assert_match new_name, response.body
	end

	test "moderators and normal users can't edit tags" do
    @tag = tags(:basic_tag_one)
		new_name = "Edited tag"
		sign_in(@moderator)
		get root_path
		get tag_path(@tag.id)
		get edit_tag_path(@tag)
		assert_redirected_to root_url
		assert_not flash.empty?
		patch tag_path, params: { tag: { name: new_name, description: @tag.description, 
                                   tag_category_id: @tag.tag_category.id }}
		get tag_path(@tag)
		assert_no_match new_name, response.body
    delete destroy_user_session_path
		sign_in(@regular_user_one)
		get root_path
		get tag_path(@tag.id)
		get edit_tag_path(@tag)
		assert_redirected_to root_url
		assert_not flash.empty?
		patch tag_path, params: { tag: { name: new_name, description: @tag.description, 
                                   tag_category_id: @tag.tag_category.id }}
		get tag_path(@tag)
		assert_no_match new_name, response.body
	end

	test "an admin can delete a user" do
		sign_in(@admin)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		assert_difference 'User.count', -1 do
			delete user_path(@regular_user_one)
		end
	end

	test "a non-admin can't delete a user" do
		sign_in(@moderator)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		assert_no_difference 'User.count' do
			delete user_path(@regular_user_one)
		end
    delete destroy_user_session_path

		sign_in(@regular_user_two)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		assert_no_difference 'User.count' do
			delete user_path(@regular_user_one)
		end
    delete destroy_user_session_path

		sign_in(@silenced)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		assert_no_difference 'User.count' do
			delete user_path(@regular_user_one)
		end
    delete destroy_user_session_path
	end
	
	test "an admin can edit a user's username and e-mail" do
		new_username = "Edited Eddy"
		new_email = "edders@example.com"
		sign_in(@admin)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		get edit_user_path(@regular_user_one)
		patch user_path, params: { user: { username: new_username,
															email: new_email } }
    @regular_user_one.reload
		assert_redirected_to user_path(@regular_user_one)
		assert_not flash.empty?
		follow_redirect!
		get user_path(@regular_user_one)

		assert_match new_username, response.body
		# I need to look into something that would escape the HTML since it messes up the matching
		# assert_match new_email, response.body
	end

	test "an admin can promote a normal user" do
		#this definition seems redundant, but if I don't include it, the variable won't initalize
		@regular_user_one = users(:regular_user_one)
		sign_in(@admin)
		get root_path
		get user_path(@regular_user_one)
		assert @regular_user_one.normal?
		assert_match @regular_user_one.username, response.body
		put promote_user_path(@regular_user_one)
		assert_redirected_to user_path(@regular_user_one)
		assert_not flash.empty?
		follow_redirect!
		@regular_user_one.reload
		assert @regular_user_one.moderator?
	end
	
	test "a moderator can unsilence a user" do
		sign_in(@moderator)
		get root_path
		get user_path(@silenced)
		assert @silenced.silenced?
		assert_match @silenced.username, response.body
		put unsilence_user_path(@silenced)
		assert_redirected_to user_path(@silenced)
		assert_not flash.empty?
		follow_redirect!
		@silenced.reload
		assert @silenced.normal?
	end
	
	test "a moderator can silence a user" do
		sign_in(@moderator)
		get root_path
		get user_path(@regular_user_one)
		assert @regular_user_one.normal?
		assert_match @regular_user_one.username, response.body
		put silence_user_path(@regular_user_one)
		assert_redirected_to user_path(@regular_user_one)
		assert_not flash.empty?
		follow_redirect!
		@regular_user_one.reload
		assert @regular_user_one.silenced?
	end

	test "regular users can't promote a user to moderator" do
		sign_in(@regular_user_one)
		get root_path
		get user_path(@regular_user_two)
		assert @regular_user_two.normal?
		put promote_user_path(@regular_user_two)
		@regular_user_two.reload
		assert_not @regular_user_two.moderator?
		assert @regular_user_two.normal?
	end

	test "regular users can't unsilence silenced users" do
		sign_in(@regular_user_one)
		get root_path
		get user_path(@silenced)
		assert @silenced.silenced?
		put unsilence_user_path(@silenced)
		@silenced.reload
		assert_not @silenced.normal?
		assert @silenced.silenced?
	end

	test "a silenced user can't unsilence themselves" do
		sign_in(@silenced)
		get root_path
		get user_path(@silenced)
		assert @silenced.silenced?
		put unsilence_user_path(@silenced)
		@silenced.reload
		assert_not @silenced.normal?
		assert @silenced.silenced?
	end

	test "a regular user can't edit their e-mail address or username" do
		new_email = "my_new_email@example.com"
		new_username = "Edited Edward"
		original_email = @regular_user_one.email
		original_username = @regular_user_one.username
		sign_in(@regular_user_one)
		get root_path
		get user_path(@regular_user_one)
		assert_match @regular_user_one.username, response.body
		get edit_user_path(@regular_user_one)
		patch user_path, params: { user: { username: new_username,
															email: new_email } }
		assert_redirected_to user_path(@regular_user_one)
		assert_not flash.empty?
		follow_redirect!
		get user_path(@regular_user_one)

		refute_match new_username, response.body
		refute_match new_email, response.body

		assert_match original_username, response.body
		assert_match original_username, response.body

		assert_equal @regular_user_one.email, original_email
		assert_equal @regular_user_one.username, original_username
	end

	test "a moderator can switch the trusted flag on a normal user" do
		sign_in(@moderator)
		get user_path(@regular_user_one)
		assert_not @regular_user_one.trusted?

		put trust_user_path(@regular_user_one)
		@regular_user_one.reload
		assert @regular_user_one.trusted?

		get user_path(@regular_user_one)
		put untrust_user_path(@regular_user_one)
		@regular_user_one.reload
		assert_not @regular_user_one.trusted?
	end

	test "a normal user cannot switch their own trusted flag" do
		sign_in(@regular_user_one)
		get user_path(@regular_user_one)
		assert_not @regular_user_one.trusted?
		assert @regular_user_one.normal?

		put trust_user_path(@regular_user_one)
		@regular_user_one.reload
		assert_not @regular_user_one.trusted?
		delete destroy_user_session_path

		sign_in(@trusted)
		get user_path(@trusted)
		assert @trusted.normal?
		assert @trusted.trusted?

		put untrust_user_path(@trusted)
		@trusted.reload
		assert @trusted.trusted?
	end

	test "a normal user can't switch the trusted flag of another user" do
		sign_in(@regular_user_one)
		assert @regular_user_one.normal?

		get user_path(@regular_user_two)
		assert_not @regular_user_two.trusted?
		put trust_user_path(@regular_user_two)
		@regular_user_two.reload
		assert_not @regular_user_two.trusted?

		get user_path(@trusted)
		assert @trusted.trusted?
		put untrust_user_path(@trusted)
		assert @trusted.trusted?
	end

	test "a normal user can't set their own initial premium flag" do
		sign_in(@regular_user_one)
		assert @regular_user_one.normal?
		assert_not @regular_user_one.initial_premium?

		get user_path(@regular_user_one)
		patch user_path, params: { user: { initial_premium: true } }

		@regular_user_one.reload
		assert_not @regular_user_one.initial_premium?
	end

	test "an admin can set a user's initial premium flag" do
		assert_not @regular_user_two.initial_premium?

		sign_in(@admin)
		get user_path(@regular_user_two)
		patch user_path, params: { user: { initial_premium: :true }}

		@regular_user_two.reload
		assert @regular_user_two.initial_premium?
	end
end
