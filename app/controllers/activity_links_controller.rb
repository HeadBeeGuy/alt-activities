# This is pretty inelegant and likely mixes up or misuses Rails conventions.
# URL persistence won't be important so if I come back to revise this, it's
# okay if the routes change.
# Also, verification is handled in the controller since I was having trouble
# getting Pundit to work with this class.

class ActivityLinksController < ApplicationController
  before_action :authenticate_user!, except: :index

  # it feels a little weird calling it "new" but I suppose it's appropriate
  def new
    @inspired_activity = Activity.find(params[:source_id])
    unless ( current_user.activities.include?(@inspired_activity) ||
        current_user.moderator? || current_user.admin? )
      redirect_to @inspired_activity
      flash[:warning] = "You can only create links to your own activities."
    end
  end

  def link_search
    @inspired_activity = Activity.find(params[:source_id])
    if params[:search]
      @activities = Activity.where('name ILIKE ? OR short_description ILIKE ? OR ' +
                                   'long_description ILIKE ?', 
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%")
                     .approved.select(:id, :name, :short_description)
                     .limit(8).order(upvote_count: :desc)
    else
      @activities = nil
    end
  end

  def create
    @inspired_activity = Activity.find(params[:inspired_id])
    @original_activity = Activity.find(params[:activity_link][:id])
    @activity_link = ActivityLink.new(inspired: @inspired_activity,
                                      original: @original_activity)
    if ( current_user.activities.include?(@inspired_activity) ||
        current_user.moderator? || current_user.admin? ) && @activity_link.save 
      flash[:success] = "You linked the activities!"
    else
      flash[:warning] = "You can only create links to your own activities."
    end
    redirect_to @inspired_activity
  end

  def index
    @activity_links = ActivityLink.includes(:original, :inspired)
      .page(params[:page]).order(created_at: :asc).per(20)
  end

  def destroy
    # Not yet implemented - going to wait until the functionality is live and I
    # understand it better
  end
end
