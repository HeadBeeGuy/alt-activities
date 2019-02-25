
class EnglipediaActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @activities = EnglipediaActivity.all
  end

  def show
    # the archive location may change in the future
    englipedia_file_root = "http://englipedia.co/www.englipedia.net"
    @activity = EnglipediaActivity.find(params[:id])
    # making it sub! modifies @activity's file list as well, but it doesn't
    # seem to save it to the db. But if I take it off, it won't persist the
    # substitution in @links. I think I'm missing an obvious Ruby pattern here,
    # but I'll have to tinker with it later.
    @links = @activity.attached_files.each { |link| link.sub!(/\.\./, englipedia_file_root) }
  end

  def edit
    @activity = EnglipediaActivity.find(params[:id])
  end

  def update
    @activity = EnglipediaActivity.find(params[:id])
    if @activity.update_attributes(englipedia_activity_params)
      flash[:success] = "Updated activity info."
      redirect_to @activity
    else
      render 'edit'
    end
  end

  def destroy
    @activity = EnglipediaActivity.find(params[:id])
    @activity.destroy
    flash[:success] = "Activity deleted."
    redirect_to englipedia_activities_url
  end

  def convert
    @activity = EnglipediaActivity.find(params[:id])
    if @activity.convert_to_regular_activity
      # @activity.converted!
      redirect_to modqueue_url
    end
  end

  private
    def englipedia_activity_params
      params.require(:englipedia_activity).permit(:title, :author,
                                                  :submission_date,
                                                  :estimated_time, :speaking,
                                                  :listening, :reading,
                                                  :writing, :description)
    end
    
end
