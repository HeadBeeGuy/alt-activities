class SitePagesController < ApplicationController

	def home
    @top10 = Activity.approved.limit(10).select(:id, :name, :upvote_count, :short_description)
      .order(upvote_count: :desc)
    @newest = Activity.approved.limit(10).select(:id, :name, :short_description)
      .order(created_at: :desc)
    @workshop_activities = Activity.approved.where(workshop: :true)
      .select(:id, :name, :short_description).order(created_at: :desc)
		@top_posts = FrontPagePost.order(created_at: :desc).limit(3)
      .select(:id, :title, :excerpt)
    @comments = Comment.order(created_at: :desc).limit(5).visible
      .select(:id, :content, :commentable_id, :commentable_type)
	end

  def modqueue
    # I'd prefer to do this with Pundit, but I'm not sure how to do it
    # when there isn't an associated model in this controller
    unless user_signed_in? && ( current_user.admin? || current_user.moderator? )
      flash[:warning] = "Sorry, but you can't access this page."
      redirect_to root_url
    end
    @unapproved = Activity.unapproved.select(:id, :name, :short_description)
    @edited = Activity.edited.select(:id, :name, :user_id, :short_description)
    @unchecked = Activity.where(checked: :false).select(:id, :name, :short_description)
    @comments = Comment.unapproved
    @newest_users = User.select(:id, :username, :created_at).order(created_at: :desc)
      .limit(5)
    @upvotes = Upvote.order(created_at: :desc).includes(:user, :activity).limit(5)
    @activity_count = Activity.count
    @user_count = User.count
  end
  
  def es
    @es_activities = Tag.find_by_name("Elementary School").activities.approved.
      order(created_at: :desc).select(:id, :name, :short_description).page(params[:page]).per(40)
    @textbooks = Textbook.ES.current.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
    @old_textbooks = Textbook.ES.obsolete.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
  end
  
  def jhs
    @jhs_activities = Tag.find_by_name("Junior High School").activities.approved.
      order(created_at: :desc).select(:id, :name, :short_description).page(params[:page]).per(40)
    @textbooks = Textbook.JHS.current.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
    @old_textbooks = Textbook.JHS.obsolete.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
  end
  
	def hs
    @hs_activities = Tag.find_by_name("High School").activities.approved.
      order(created_at: :desc).select(:id, :name, :short_description).page(params[:page]).per(30)
    @textbooks = Textbook.HS.current.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
    @old_textbooks = Textbook.HS.obsolete.select(:id, :name, :year_published)
      .order(year_published: :desc, name: :asc)
  end

  def special_needs
    @sn_activities = Tag.find_by_name("Special Needs").activities.approved.
      order(created_at: :desc).select(:id, :name, :short_description).page(params[:page]).per(30)
    @textbooks = []
    @old_textbooks = []
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
    @top6= User.select(:id, :username, :activity_count, :home_country, :location, 
      :initial_premium, :trusted)
      .where(trusted: :true).order(activity_count: :desc).limit(6)
  end

  def render_compact_shoutbox
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
