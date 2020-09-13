class SitePagesController < ApplicationController

	def home
    @top10 = Activity.approved.limit(10).select(:id, :name, :upvote_count, :short_description)
      .order(upvote_count: :desc)
    @newest = Activity.approved.limit(10).select(:id, :name, :short_description)
      .order(created_at: :desc)
		@top_posts = FrontPagePost.order(created_at: :desc).limit(3)
      .select(:id, :title, :excerpt)
    @comments = Comment.order(created_at: :desc).limit(5).visible
      .select(:content, :commentable_id, :commentable_type)
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
    @upvotes = Upvote.order(created_at: :desc).includes(:user, :activity).limit(5)
  end
  
  def es
    @all_activities = Tag.find_by_name("Elementary School").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_name("Elementary School").id, Tag.find_by_name("Warm-up").id], 10)
    @top10 = Tag.find_by_name("Elementary School").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.ES.select(:id, :name).order(name: :asc)
  end
  
  def jhs
    @all_activities = Tag.find_by_name("Junior High School").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_name("Junior High School").id, Tag.find_by_name("Warm-up").id], 10)
    @top10 = Tag.find_by_name("Junior High School").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.JHS.select(:id, :name).order(name: :asc)
  end
  
	def hs
    @all_activities = Tag.find_by_name("High School").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_name("High School").id, Tag.find_by_name("Warm-up").id], 10)
    @top10 = Tag.find_by_name("High School").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.HS.select(:id, :name).order(name: :asc)
  end

	def conversation
    @all_activities = Tag.find_by_name("Conversation").activities.order(created_at: :desc)
			.select(:id, :name, :short_description, :upvote_count).page(params[:page])
      .where(status: :approved)
    @warmups = Activity.find_with_all_tags([
      Tag.find_by_name("Conversation").id, Tag.find_by_name("Warm-up").id], 10)
    @top10 = Tag.find_by_name("Conversation").activities.order(upvote_count: :desc)
      .select(:id, :name, :upvote_count, :short_description).approved.limit(10)
    @textbooks = Textbook.Conversation.select(:id, :name).order(name: :asc)
  end

	def warmups
    @top10_es = Activity.find_with_all_tags([
      Tag.find_by_name("Elementary School").id, Tag.find_by_name("Warm-up").id], 10)
    @top10_jhs = Activity.find_with_all_tags([
      Tag.find_by_name("Junior High School").id, Tag.find_by_name("Warm-up").id], 10)
    @all_warmups = Tag.find_by_name("Warm-up").activities.order(upvote_count: :desc)
      .select(:id, :name, :short_description).where(status: :approved).page(params[:page])
  end

  def grammar
		@tags = TagCategory.find_by_name("Grammar points").tags.select(:id, :name, :description)
		  .order(name: :asc)
  end

  def themes
    @theme_tags = TagCategory.find_by_name("Themes").tags.select(:id, :name, :description)
      .order(name: :asc)
    @holiday_tags = TagCategory.find_by_name("Holiday").tags.select(:id, :name, :description)
      .order(name: :asc)
  end

  def contributors
    # Currently offsetting the count by 1 since Englipedia Archive is the top user
    # by activities, and that's not really fair
    @top10 = User.select(:id, :username, :activity_count, :home_country, :location, :bio)
      .order(activity_count: :desc).limit(12).offset(1)
    @top3 = @top10[0..2]
    @top4to12 = @top10[3..11]
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
