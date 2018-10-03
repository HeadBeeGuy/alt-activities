require 'test_helper'

class FrontPagePostsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user = users(:regular_user_one)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @normal_post = front_page_posts(:front_page_post_one)
  end


  test "an admin can successfully create a front page post" do
    post_title = "Big news!"
    post_excerpt = "You wont believe it! Also I cant use apostrophes!"
    post_body = "This is so momentous that it cant leave test!"

    sign_in(@admin)
    get new_front_page_post_path
    assert_difference "FrontPagePost.count", 1 do
      post front_page_posts_path, params: { front_page_post: {
        title: post_title, excerpt: post_excerpt, content: post_body }}
    end

    get root_path
    assert_match post_title, response.body
    assert_match post_excerpt, response.body
    assert_no_match post_body, response.body

    newest_post = FrontPagePost.find_by_title(post_title)

    get posts_path(newest_post)
    assert_match post_title, response.body
    assert_no_match post_excerpt, response.body
    assert_match post_body, response.body
  end

  test "a non-admin can't create front page posts" do
    post_title = "Unnecessary post"
    post_excerpt = "I am in no position to make a post!"
    post_body = "If just anyone could make posts, it would be total bedlam!"

    sign_in(@moderator)
    get new_front_page_post_path
    assert_no_difference "FrontPagePost.count" do
      post front_page_posts_path, params: { front_page_post: {
        title: post_title, excerpt: post_excerpt, content: post_body }}
    end
    get root_path
    assert_no_match post_title, response.body
    delete destroy_user_session_path

    sign_in(@regular_user)
    get new_front_page_post_path
    assert_no_difference "FrontPagePost.count" do
      post front_page_posts_path, params: { front_page_post: {
        title: post_title, excerpt: post_excerpt, content: post_body }}
    end
    get root_path
    assert_no_match post_title, response.body
    delete destroy_user_session_path

    sign_in(@silenced)
    get new_front_page_post_path
    assert_no_difference "FrontPagePost.count" do
      post front_page_posts_path, params: { front_page_post: {
        title: post_title, excerpt: post_excerpt, content: post_body }}
    end
    get root_path
    assert_no_match post_title, response.body
    delete destroy_user_session_path
  end

  test "an admin can successfully edit a front page post" do
    new_title = "Revised post"
    new_excerpt = "I changed my mind."
    new_body = "Scratch that last post."
    
    sign_in(@admin)
    get root_path
    assert_match @normal_post.title, response.body
    assert_match @normal_post.excerpt, response.body
    get posts_path(@normal_post) # I think this path is a shortcut I defined - not generated via resources in the routes file
    assert_match @normal_post.content, response.body

    get edit_front_page_post_path(@normal_post)
    patch front_page_post_path, params: { front_page_post: {
      title: new_title, excerpt: new_excerpt, content: new_body }}

    get root_path
    assert_match new_title, response.body
    assert_match new_excerpt, response.body
    get posts_path(@normal_post) 
    assert_match new_body, response.body
  end

  test "an admin can successfully delete a post" do
    sign_in(@admin)
    get root_path
    assert_match @normal_post.title, response.body
    former_title = @normal_post.title

    assert_difference "FrontPagePost.count", -1 do
      delete front_page_post_path(@normal_post)
    end

    get root_path
    assert_no_match former_title, response.body
  end

  test "a non-admin can't edit or delete front page posts" do
    new_title = "Hacked post!"
    new_excerpt = "I can edit posts!"
    new_body = "Time to call a new coder!"

    sign_in(@moderator)
    get root_path
    assert_match @normal_post.title, response.body
    get edit_front_page_post_path(@normal_post)
    patch front_page_post_path, params: { front_page_post: {
      title: new_title, excerpt: new_excerpt, content: new_body }}
    get root_path
    assert_no_match new_title, response.body
    get posts_path(@normal_post)
    assert_no_match new_body, response.body
    assert_no_difference "FrontPagePost.count" do
      delete front_page_post_path(@normal_post)
    end
    get root_path
    assert_match @normal_post.title, response.body
    delete destroy_user_session_path

    sign_in(@regular_user)
    get root_path
    assert_match @normal_post.title, response.body
    get edit_front_page_post_path(@normal_post)
    patch front_page_post_path, params: { front_page_post: {
      title: new_title, excerpt: new_excerpt, content: new_body }}
    get root_path
    assert_no_match new_title, response.body
    get posts_path(@normal_post)
    assert_no_match new_body, response.body
    assert_no_difference "FrontPagePost.count" do
      delete front_page_post_path(@normal_post)
    end
    get root_path
    assert_match @normal_post.title, response.body
    delete destroy_user_session_path

    sign_in(@silenced)
    get root_path
    assert_match @normal_post.title, response.body
    get edit_front_page_post_path(@normal_post)
    patch front_page_post_path, params: { front_page_post: {
      title: new_title, excerpt: new_excerpt, content: new_body }}
    get root_path
    assert_no_match new_title, response.body
    get posts_path(@normal_post)
    assert_no_match new_body, response.body
    assert_no_difference "FrontPagePost.count" do
      delete front_page_post_path(@normal_post)
    end
    get root_path
    assert_match @normal_post.title, response.body
    delete destroy_user_session_path
  end
end
