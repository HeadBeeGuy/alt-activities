# previously the counts were pawned off to Sidekiq workers
# hopefully this doesn't lead to a case where one user can flood the database
# by clicking the upvote button a zillion times

class UpvotesController < ApplicationController
	before_action :authenticate_user!

	# adapting this, as always, from the Relationships model in Hartl's Rails tutorial
	def create
		@activity = Activity.find(params[:activity_id])
		unless Upvote.find_by(activity_id: @activity.id, user_id: current_user.id )
			current_user.upvotes.create!(activity_id: @activity.id)
			# CountUpvotesWorker.perform_async(@activity.id)
			@activity.update!(upvote_count: @activity.upvotes.count)

			respond_to do |format|
				format.html { redirect_to @activity }
				format.js
			end
		else
			redirect_to @activity
		end
	end

	def destroy
		@activity = Activity.find(params[:activity_id])
		@upvote = current_user.upvotes.find_by(activity_id: @activity.id)
		@upvote.delete
		# CountUpvotesWorker.perform_async(@activity.id)
		@activity.update!(upvote_count: @activity.upvotes.count)

		respond_to do |format|
			format.html { redirect_to @activity }
			format.js 
		end
	end

end
