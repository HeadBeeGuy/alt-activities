
# Update the upvote count for a given activity
# This may not scale as the upvote table gets enormous
# At that point, we may have to make a batch job that handles all upvote tallying at 2 am or something like that
class CountUpvotesWorker
  include Sidekiq::Worker

	sidekiq_options retry: 0

	# per the Sidekiq documentation, we only want to pass very simple parameters in
	# not the class object - just the id, so we can find it in here!
  def perform(activity_id)
		@activity = Activity.find(activity_id) # does this load the entire Activity object into memory? that seems inefficient
		@activity.update!(upvote_count: @activity.upvotes.count)
  end
end
