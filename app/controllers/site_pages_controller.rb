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
    @all_activities = Tag.find_by_short_name("ES").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("ES").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("ES").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count).where(status: :approved).limit(10)
    @textbooks = Textbook.ES.select(:id, :name).order(name: :asc)
  end
  
  def jhs
    @all_activities = Tag.find_by_short_name("JHS").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("JHS").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("JHS").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count).where(status: :approved).limit(10)
    @textbooks = Textbook.JHS.select(:id, :name).order(name: :asc)
  end
  
	def hs
    @all_activities = Tag.find_by_short_name("HS").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("HS").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("HS").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count).where(status: :approved).limit(10)
    @textbooks = Textbook.HS.select(:id, :name).order(name: :asc)
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
