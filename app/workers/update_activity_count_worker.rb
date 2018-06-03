
# Set a user's activity_count variable to their total number of approved activities
# This should only go up or down by one, but just incrementing the variable seems like
# it would eventually bite me in the butt with concurrency or a race condition or some such

class UpdateActivityCountWorker
	include Sidekiq::Worker

	sidekiq_options retry: 0

	def perform(user_id)
		@user = User.find(user_id)
		@user.update!(activity_count: @user.activities.approved.count)
	end
end
