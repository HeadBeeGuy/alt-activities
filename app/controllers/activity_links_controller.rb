# This is pretty inelegant and likely mixes up or misuses Rails conventions.
# URL persistence won't be important so if I come back to revise this, it's
# okay if the routes change.

class ActivityLinksController < ApplicationController

  # it feels a little weird calling it "new" but I suppose it's appropriate
  def new
    @source_activity = Activity.find(params[:source_id])
    authorize @source_activity
  end

  def link_search
    @source_activity = Activity.find(params[:source_id])
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
    @source_activity = Activity.find(params[:source_id])
    @inspired_activity = Activity.find(params[:activity_link][:id])
    @activity_link = ActivityLink.new(inspired: @source_activity,
                                      original: @inspired_activity)
    authorize @activity_link
    if @activity_link.save
      flash[:success] = "You linked the activities!"
    end
    redirect_to @source_activity
  end

  def destroy
    # Not yet implemented - going to wait until the functionality is live and I
    # understand it better
  end
end
