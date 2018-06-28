require 'test_helper'

class JobPostTest < ActiveSupport::TestCase

	def setup
		@job_post = job_posts(:job_post_one)
	end

	test "a job post's title must be present" do
		@job_post.title = ""
		assert_not @job_post.valid?
	end

	test "a job post's title can't be over 400 characters" do
		@job_post.title = "a" * 401
		assert_not @job_post.valid?
	end

	test "a job post's external URL can't be over 250 characters" do
		@job_post.external_url = "a" * 251
		assert_not @job_post.valid?
	end

	test "a job post's content must be present" do
		@job_post.content = ""
		assert_not @job_post.valid?
	end

	test "a job post's content can't be over 5000 characters" do
		@job_post.content = "a" * 5001
		assert_not @job_post.valid?
	end
end
