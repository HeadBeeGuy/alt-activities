class ActivitiesController < ApplicationController
  
  def new
    if user_signed_in?
      @activity = Activity.new
    else
      flash[:error] = "You must log in to create an activity."
      redirect_to new_user_session_path
    end
  end
  
  def create
    # should I do another logged in check here?
    @activity = Activity.create(activity_params)
    @activity.user_id = current_user.id # will this assign it correctly?
    if @activity.save
      flash[:success] = "Activity created! Behold!"
      redirect_to @activity
    else
      render 'site_pages#home'
    end
  end
  
  def show
    @activity = Activity.find(params[:id])
  end
  
  def index
    @activities = Activity.all
  end
  
  private
  
    def activity_params
      params.require(:activity).permit(:name, :short_description, :long_description, :time_estimate,
                                        :user_id)
    end
end
