require 'test_helper'

class JobPostsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @regular_user = users(:regular_user_one)
    @admin = users(:admin_user_one)
    @moderator = users(:moderator_user_one)
    @silenced = users(:silenced_user_one)
    @job_post = job_posts(:job_post_one)
  end

  test "an admin can successfully create a job post" do
    job_title = "Pig lipstick technician"
    job_url = "http://www.example.com"
    job_description = "The pigs have trouble applying it because they have no thumbs."

    sign_in(@admin)
    get jobs_path
    assert_no_match job_title, response.body
    get new_job_post_path
    assert_difference "JobPost.count", 1 do
      post job_posts_path, params: { job_post: {
        title: job_title, external_url: job_url, content: job_description }}
    end
    get jobs_path
    assert_match job_title, response.body
    assert_match job_url, response.body
    assert_match job_description, response.body
  end

  test "an admin can successfully edit a job post" do
    new_job_title = "Edited job"
    new_job_url = "http://edited.example.com"
    new_job_description = "Revised!"

    sign_in(@admin)
    get jobs_path
    assert_match @job_post.title, response.body
    assert_match @job_post.external_url, response.body
    assert_match @job_post.content, response.body
    get edit_job_post_path(@job_post)
    patch job_post_path(@job_post), params: { job_post: {
      title: new_job_title, external_url: new_job_url, content: new_job_description }}
    get jobs_path
    assert_match new_job_title, response.body
    assert_match new_job_url, response.body
    assert_match new_job_description, response.body
  end

  test "an admin can successfully delete job posts" do
    former_title = @job_post.title
    former_url = @job_post.external_url
    former_content = @job_post.content

    sign_in(@admin)
    get jobs_path
    assert_match former_title, response.body
    assert_match former_url, response.body
    assert_match former_content, response.body
    
    assert_difference "JobPost.count", -1 do
      delete job_post_path(@job_post)
    end

    get jobs_path
    assert_no_match former_title, response.body
    assert_no_match former_url, response.body
    assert_no_match former_content, response.body
  end

  test "a moderator, normal, or silenced user cannot create job posts" do
    job_title = "Unauthorized gig"
    job_url = "http://fake.example.com"
    job_description = "My cousin needs someone to take the pickles out of his sandwiches."

    get jobs_path
    assert_no_match job_title, response.body
    assert_no_match job_url, response.body
    assert_no_match job_description, response.body

    sign_in(@moderator)
    assert_no_difference "JobPost.count" do
      get new_job_post_path
      post job_posts_path, params: { job_post: {
        title: job_title, external_url: job_url, content: job_description } }
    end
    delete destroy_user_session_path

    sign_in(@regular_user)
    assert_no_difference "JobPost.count" do
      get new_job_post_path
      post job_posts_path, params: { job_post: {
        title: job_title, external_url: job_url, content: job_description } }
    end
    delete destroy_user_session_path

    sign_in(@silenced)
    assert_no_difference "JobPost.count" do
      get new_job_post_path
      post job_posts_path, params: { job_post: {
        title: job_title, external_url: job_url, content: job_description } }
    end
    delete destroy_user_session_path

    get jobs_path
    assert_no_match job_title, response.body
    assert_no_match job_url, response.body
    assert_no_match job_description, response.body
  end

  test "a moderator, normal, or silenced user cannot edit or delete job posts" do
    new_job_title = "Hacked job!"
    new_job_url = "http://insecure-site.example.com"
    new_job_description = "Advance the interest of wrong-doers!"

    get jobs_path
    assert_match @job_post.title, response.body
    assert_match @job_post.external_url, response.body
    assert_match @job_post.content, response.body

    sign_in(@moderator)
    get edit_job_post_path(@job_post)
    patch job_post_path(@job_post), params: { job_post: {
      title: new_job_title, external_url: new_job_url, content: new_job_description }}
    assert_no_difference "JobPost.count" do
      delete job_post_path(@job_post)
    end
    delete destroy_user_session_path

    sign_in(@regular_user)
    get edit_job_post_path(@job_post)
    patch job_post_path(@job_post), params: { job_post: {
      title: new_job_title, external_url: new_job_url, content: new_job_description }}
    assert_no_difference "JobPost.count" do
      delete job_post_path(@job_post)
    end
    delete destroy_user_session_path

    sign_in(@silenced)
    get edit_job_post_path(@job_post)
    patch job_post_path(@job_post), params: { job_post: {
      title: new_job_title, external_url: new_job_url, content: new_job_description }}
    assert_no_difference "JobPost.count" do
      delete job_post_path(@job_post)
    end
    delete destroy_user_session_path

    get jobs_path
    assert_match @job_post.title, response.body
    assert_match @job_post.external_url, response.body
    assert_match @job_post.content, response.body
  end
end
