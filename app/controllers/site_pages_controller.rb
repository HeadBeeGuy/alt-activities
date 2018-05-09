class SitePagesController < ApplicationController

	def home
		@top5 = Activity.limit(5).select(:id, :name, :upvote_count).order(upvote_count: :desc)
							.where(status: :approved)
		@newest5 = Activity.limit(5).select(:id, :name, :upvote_count).order(created_at: :desc)
							.where(status: :approved)
	end

  def about
  end
  
  def es
    # I hope this query isn't too brittle
    # Would I be an ogre if I accessed by id? this will probably be a frequently viewed page
    # but if the id ever changed, this page would break!
		@activites = Tag.find_by_short_name("ES").activities.order(upvote_count: :desc)
									.select(:id, :name, :short_description, :upvote_count)
									.includes(:tags)
  end
  
  def jhs
    @activites = Tag.find_by_short_name("JHS").activities.order(upvote_count: :desc)
									.select(:id, :name, :short_description, :upvote_count)
									.includes(:tags)
  end
  
  def grammar
    @tags = TagCategory.find_by_name("Grammar points").tags
  end
end
