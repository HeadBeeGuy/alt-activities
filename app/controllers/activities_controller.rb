class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def new
    @activity = Activity.new
    authorize @activity
    @tags = Tag.all
    @tag_categories = TagCategory.all
  end
  
  def create
    @activity = current_user.activities.build(activity_params)
    @tag_categories = TagCategory.all
    authorize @activity
    if @activity.save
      new_taggings = params[:activity][:tag_ids]
      new_taggings.each do |tagging|
        if tagging.present? # the first item in the array is always blank
          Tagging.create!(activity_id: @activity.id, tag_id: tagging)
        end
      end
      flash[:success] = "Activity submitted! Once it's approved, it will show up on the site."
      redirect_to activities_url
    else
      render 'new'
    end
  end
  
  def edit
    @activity = Activity.find(params[:id])
    authorize @activity
    @tag_categories = TagCategory.all
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
			UpdateActivityCountWorker.perform_async(@activity.user.id)
      redirect_to activities_url
    else
      render 'edit'
    end
  end
  
  def destroy
    @activity = Activity.find(params[:id])
    authorize @activity
		activity_user_id = @activity.user.id # can't access the user id after it's destroyed
    @activity.destroy
    flash[:success] = "Activity deleted!"
		UpdateActivityCountWorker.perform_async(activity_user_id)
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
			UpdateActivityCountWorker.perform_async(@activity.user.id)
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
    end
		UpdateActivityCountWorker.perform_async(@activity.user.id)
  end
  
  def index
		@activities = Activity.where(status: :approved).order(upvote_count: :desc)
			.select(:name, :short_description, :upvote_count, :id)
			.page(params[:page])
  end
  
  def modqueue
    @unapproved = Activity.where(status: [:unapproved])
    authorize @unapproved
    @edited = Activity.where(status: [:edited])
  end
  
  private
  
    def activity_params
      params.require(:activity).permit(:name, :short_description, :long_description, :time_estimate,
                                        :user_id, :tag_ids, documents: [])
    end

    # handles cases when the activity is being edited and tags are being removed
    # returns an array of tag ids that will need to be deleted
    def taggings_to_be_deleted(old_tag_array, new_tag_array)
      old_tag_array.reject { |tag_id| new_tag_array.include?(tag_id.to_s) }
    end
end
