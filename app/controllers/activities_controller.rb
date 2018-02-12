class ActivitiesController < ApplicationController
  #this is Devise's authentication, but do I need it here?
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :destroy]
  
  def new
    #should this be handled with a before_action filter instead?
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
    @activity.user_id = current_user.id
    if @activity.save
      flash[:success] = "Activity created! Behold!"
      redirect_to @activity
    else
      render 'site_pages#home'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
  end
  
  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(activity_params)
      flash[:success] = "Activity updated!"
      redirect_to @activity
    else
      render 'edit'
    end
  end
  
  def destroy
    Activity.find(params[:id]).destroy
    flash[:success] = "Activity deleted! It's not coming back!"
    redirect_to activities_url
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
    
    # only allow either the submitter or an admin to edit or delete things
    # this will eventually change, as it will be submitted to the moderator queue for verification instead
    # pinched from Hartl's Rails Tutorial
    def correct_user
      if !user_signed_in?
        flash[:error] = "Please sign in."
        redirect_to activities_url
      else
        @activity = current_user.activities.find_by(id: params[:id])
        redirect_to activities_url if @activity = nil? # or current_user is not an admin
      end
    end
end
