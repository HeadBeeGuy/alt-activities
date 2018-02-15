class ActivitiesController < ApplicationController
  #this is Devise's authentication, but do I need it here?
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def new
    #should this be handled with a before_action filter instead?
    if user_signed_in?
      @activity = Activity.new
      @tags = Tag.all
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
      new_taggings = params[:activity][:tag_ids]
      new_taggings.each do |tagging|
        if tagging.present? # the first item in the array is always blank
          Tagging.create!(activity_id: @activity.id, tag_id: tagging)
        end
      end
      flash[:success] = "Activity created! Behold!"
      redirect_to @activity
    else
      render 'edit'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
    @tags = Tag.all
  end
  
  def update
    @activity = Activity.find(params[:id])
    # one wrinkle is that taggings could theoretically be removed as well as created
    updated_taggings = params[:activity][:tag_ids]
    delete_these = taggings_to_be_deleted(@activity.tags.ids, updated_taggings)
    
    delete_these.each do |tagging|
      Tagging.find_by(activity: @activity.id, tag_id: tagging).destroy
    end
    
    #check to see if taggings already exist, and if there's a new tagging, create it
    updated_taggings.each do |tagging|
      if tagging.present? # the first item in the array is always blank
        Tagging.find_or_create_by!(activity_id: @activity.id, tag_id: tagging)
      end
    end
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
                                        :user_id, :tag_ids)
    end
    
    # only allow either the submitter or an admin to edit or delete things
    # this will eventually change, as it will be submitted to the moderator queue for verification instead
    # pinched from Hartl's Rails Tutorial
    # right now this is not doing its job correctly - users can edit each other's activities!
    def correct_user
      if !user_signed_in?
        flash[:error] = "Please sign in."
        redirect_to activities_url
      else
        @activity = current_user.activities.find_by(id: params[:id])
        redirect_to activities_url if @activity = nil? # or current_user is not an admin
      end
    end
    
    # handles cases when the activity is being edited and tags are being removed
    # returns an array of tag ids that will need to be deleted
    def taggings_to_be_deleted(old_tag_array, new_tag_array)
      old_tag_array.reject { |tag_id| new_tag_array.include?(tag_id.to_s) }
    end
end
