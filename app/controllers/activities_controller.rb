class ActivitiesController < ApplicationController
  #this is Devise's authentication, but do I need it here?
  before_action :authenticate_user!, only: [:edit, :update]
  
  def new
    #should this be handled with a before_action filter instead?
    if user_signed_in?
      @activity = Activity.new
      authorize @activity
      @tags = Tag.all
    else
      flash[:warning] = "You must log in to create an activity."
      redirect_to new_user_session_url
    end
  end
  
  def create
    # should I do another logged in check here?
    @activity = Activity.create(activity_params)
    @activity.user_id = current_user.id
    if authorize @activity && @activity.save
      new_taggings = params[:activity][:tag_ids]
      new_taggings.each do |tagging|
        if tagging.present? # the first item in the array is always blank
          Tagging.create!(activity_id: @activity.id, tag_id: tagging)
        end
      end
      flash[:success] = "Activity submitted! Once it's approved, it will show up on the site."
      redirect_to @activity
    else
      render 'edit'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
    authorize @activity
    @tags = Tag.all
  end
  
  def update
    @activity = Activity.find(params[:id])
    
    authorize @activity
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
      flash[:success] = "Activity updated! Once the edits are approved, it will show up on the site."
      @activity.edited!
      redirect_to activities_url
    else
      render 'edit'
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    authorize @activity
    @activity.destroy
    flash[:success] = "Activity deleted!"
    redirect_to activities_url
  end
  
  def show
    @activity = Activity.find(params[:id])
    authorize @activity
  end
  
  def approve
    @activity = Activity.find(params[:id])
    authorize @activity
    if @activity.unapproved? || @activity.edited?
      @activity.approved!
      flash[:success] = "Activity approved!"
      redirect_to modqueue_url
    elsif @activity.approved?
      flash[:warning] = "Activity already approved!"
      redirect_to modqueue_url
    end
  end
  
  def unapprove
    @activity = Activity.find(params[:id])
    authorize @activity
    if @activity.approved?
      @activity.unapproved!
      flash[:success] = "Activity moved back to mod queue."
      redirect_to @activity
    elsif
      flash[:warning] = "How did you get here? The activity wasn't approved yet."
      redirect_to activities_url
    end
  end
  
  def index
    @activities = Activity.approved
  end
  
  def modqueue
    @activities = Activity.where(status: [:unapproved, :edited])
  end
  
  private
  
    def activity_params
      params.require(:activity).permit(:name, :short_description, :long_description, :time_estimate,
                                        :user_id, :tag_ids)
    end

    # handles cases when the activity is being edited and tags are being removed
    # returns an array of tag ids that will need to be deleted
    def taggings_to_be_deleted(old_tag_array, new_tag_array)
      old_tag_array.reject { |tag_id| new_tag_array.include?(tag_id.to_s) }
    end
end
