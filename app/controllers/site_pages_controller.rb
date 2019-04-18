class SitePagesController < ApplicationController

	def home
    @top10 = Activity.approved.limit(10).select(:id, :name, :upvote_count, :short_description)
      .order(upvote_count: :desc)
    @newest = Activity.approved.limit(10).select(:id, :name, :short_description)
      .order(created_at: :desc)
		@top_posts = FrontPagePost.order(created_at: :desc).limit(3)
      .select(:id, :title, :excerpt)
	end

  def modqueue
    # I'd prefer to do this with Pundit, but I'm not sure how to do it
    # when there isn't an associated model in this controller
    unless user_signed_in? && ( current_user.admin? || current_user.moderator? )
      flash[:warning] = "Sorry, but you can't access this page."
      redirect_to root_url
    end
    @unapproved = Activity.unapproved.select(:id, :name, :user_id, :short_description)
    @edited = Activity.edited.select(:id, :name, :user_id, :short_description)
    @comments = Comment.unapproved
    @newest_users = User.select(:id, :username, :created_at).order(created_at: :desc)
      .limit(5)
  end
  
  def es
    @all_activities = Tag.find_by_short_name("ES").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("ES").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("ES").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.ES.select(:id, :name).order(name: :asc)
  end
  
  def jhs
    @all_activities = Tag.find_by_short_name("JHS").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("JHS").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("JHS").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.JHS.select(:id, :name).order(name: :asc)
  end
  
	def hs
    @all_activities = Tag.find_by_short_name("HS").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_short_name("HS").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_short_name("HS").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.HS.select(:id, :name).order(name: :asc)
  end

	def conversation
    @all_activities = Tag.find_by_long_name("Conversation").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_long_name("Conversation").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10 = Tag.find_by_long_name("Conversation").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.Conversation.select(:id, :name).order(name: :asc)
  end

	def warmups
    @top10_es = Activity.find_with_all_tags([
      Tag.find_by_short_name("ES").id, Tag.find_by_short_name("warm-up").id], 10)
    @top10_jhs = Activity.find_with_all_tags([
      Tag.find_by_short_name("JHS").id, Tag.find_by_short_name("warm-up").id], 10)
    @all_warmups = Tag.find_by_short_name("warm-up").activities.order(upvote_count: :desc)
      .select(:id, :name, :short_description).where(status: :approved).page(params[:page])
  end

  def grammar
		@tags = TagCategory.find_by_name("Grammar points").tags.select(:id, :long_name, :description)
		  .order(long_name: :asc)
  end

  def themes
    @tags = TagCategory.find_by_name("Themes").tags.select(:id, :long_name, :description)
      .order(long_name: :asc)
  end

  def render_compact_shoutbox
    # JavaScript only at the moment. Maybe at some point I could render the
    # front page again, although unless JavaScript is enabled, I don't know how
    # the user will be able to use iShoutbox
    respond_to do |format|
      format.js
    end
  end

  def render_discord
    respond_to do |format|
      format.js
    end
  end
end
