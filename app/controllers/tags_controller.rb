class TagsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def new
    @tag = Tag.new
    authorize @tag
  end
  
  def create
    @tag = Tag.new(tag_params)
    authorize @tag
    if @tag.save
      flash[:success] = "Tag created!"
      redirect_to @tag
    else
      render 'edit'
    end
  end
  
  def edit
    @tag = Tag.find(params[:id])
    authorize @tag
  end
  
  def update
    @tag = Tag.find(params[:id])
    authorize @tag
    if @tag.update(tag_params)
      flash[:success] = "Tag updated!"
      redirect_to @tag
    else
      render 'edit'
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
		@activities = @tag.activities.approved.order(created_at: :desc)
      .select(:name, :short_description, :upvote_count, :id)
      .page(params[:page]).per(40)
		@top5 = @tag.activities.approved.limit(5).select(:id, :name, :upvote_count, :short_description)
			.order(upvote_count: :desc)
    @comment = Comment.new
    @comments = @tag.comments.visible.page(params[:page]).includes(:user).order(created_at: :asc)
  end
  
  def index
    @tag_categories = TagCategory.order(name: :asc).includes(:tags)
      .order('tags.name ASC')
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag
    @tag.destroy
    flash[:success] = "Tag destroyed!"
    redirect_to tags_url
  end
  
  private
  
    def tag_params
      params.require(:tag).permit(:name, :description, :tag_category_id, :explanation)
    end
  
end
