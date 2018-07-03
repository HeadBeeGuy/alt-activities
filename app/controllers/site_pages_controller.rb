class SitePagesController < ApplicationController

	def home
		@top5 = Activity.limit(5).select(:id, :name, :upvote_count).order(upvote_count: :desc)
			.where(status: :approved)
		@newest = Activity.limit(10).select(:id, :name, :upvote_count).order(created_at: :desc)
			.where(status: :approved)
		@top_posts = FrontPagePost.order(created_at: :desc).limit(3).select(:id, :title, :excerpt)
	end

  def about
  end
  
  def es
    # I hope this query isn't too brittle
    # Would I be an ogre if I accessed by id? this will probably be a frequently viewed page
    # but if the id ever changed, this page would break!
		@activities = Tag.find_by_short_name("ES").activities.order(upvote_count: :desc)
			.select(:id, :name, :short_description, :upvote_count)
			.includes(:tags).page(params[:page]).where(status: :approved)
  end
  
  def jhs
    @activities = Tag.find_by_short_name("JHS").activities.order(upvote_count: :desc)
			.select(:id, :name, :short_description, :upvote_count)
			.includes(:tags).page(params[:page]).where(status: :approved)
  end
  
	def hs
    @activities = Tag.find_by_short_name("HS").activities.order(upvote_count: :desc)
			.select(:id, :name, :short_description, :upvote_count)
			.includes(:tags).page(params[:page])
  end

	def warmups
    @activities = Tag.find_by_short_name("warm-up").activities.order(upvote_count: :desc)
			.select(:id, :name, :short_description, :upvote_count)
			.includes(:tags).page(params[:page])
  end

  def grammar
		@tags = TagCategory.find_by_name("Grammar points").tags.select(:id, :long_name, :description)
		  .order(long_name: :asc)
  end
end
