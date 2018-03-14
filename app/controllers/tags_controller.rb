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
      redirect_to all_tags_url
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
    if @tag.update_attributes(tag_params)
      flash[:success] = "Tag updated!"
      redirect_to @tag
    else
      render 'edit'
    end
  end
  
  def show
    @tag = Tag.find(params[:id])
  end
  
  def index
    @tags = Tag.all
  end
  
  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag
    @tag.destroy
    flash[:success] = "Tag destroyed!"
    redirect_to all_tags_url
  end
  
  private
  
    def tag_params
      params.require(:tag).permit(:short_name, :long_name, :description, :tag_category_id)
    end
  
end
