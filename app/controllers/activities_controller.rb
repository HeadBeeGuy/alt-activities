class ActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def new
    @activity = Activity.new
    authorize @activity
    @tag_categories = TagCategory.all.includes(:tags)
  end
  
  def create
    @activity = current_user.activities.build(activity_params)
    @tag_categories = TagCategory.all
    authorize @activity
    if @activity.save
      flash[:success] = "Activity submitted! You can edit it if you like. It will be visible to other users once it's approved."
      redirect_to @activity
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
    @user = @activity.user
    if @activity.update(activity_params)
      # admins and moderators can edit activities without pulling them back to the mod queue
      if current_user.admin? || current_user.moderator?
        flash[:success] = "Activity updated."
        @activity.approved!
        redirect_to modqueue_url
      else
        flash[:success] = "Activity updated! Once the edits are approved, it will show up on the site."
        if @activity.approved?
          @activity.edited!
        else
          @activity.unapproved!
        end
        redirect_to @activity
      end
      @user.update(activity_count: @user.activities.approved.count)
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
    @user.update(activity_count: @user.activities.approved.count)
    redirect_to activities_url
  end
  
  def show
    @activity = Activity.find(params[:id])
    authorize @activity
    @comments = @activity.comments.visible.order(created_at: :desc)
      .includes(:user).page(params[:page])
    @comment = Comment.new
    @tagging = Tagging.new
    @activity_taggings = Tagging.where(activity: @activity).includes(:tag)
    @source_activities = @activity.source_activities
    @inspired_activities = @activity.inspired_activities
  end
  
  def approve
    @activity = Activity.find(params[:id])
    authorize @activity
    @user = @activity.user
    if @activity.unapproved? || @activity.edited?
      @activity.approved!
      flash[:success] = "Activity approved!"
      @user.update(activity_count: @user.activities.approved.count)
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
    @user.update(activity_count: @user.activities.approved.count)
  end
  
  def index
		@activities = Activity.approved.order(created_at: :desc)
			.select(:name, :short_description, :id).page(params[:page])
  end
  
	# swiping from https://stackoverflow.com/a/49517939
	# and https://stackoverflow.com/a/49635423
  def delete_attached_document
    # We have to stop people from deleting files on activities they shouldn't be able to.
    # So this parameter is somewhat clumsily passed in, because this is already kind of
    # a weird place to have this function. Perhaps there's a more elegant way!
    @activity = Activity.find(params[:activity_id_for_deletion])
    authorize @activity
    # It should be noted that :id is the ActiveStorage id for the file in question,
    # not the activity
		@document = ActiveStorage::Attachment.find(params[:id]) # not ::Blob!
		@document.purge_later
		redirect_back(fallback_location: root_url)
	end
  
  private
  
    def activity_params
      params.require(:activity).permit(:name, :short_description, :long_description, :time_estimate,
                                        :user_id, tag_ids: [], documents: [])
    end
end
