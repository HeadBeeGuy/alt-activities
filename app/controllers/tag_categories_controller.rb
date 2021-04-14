class TagCategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @tag_categories = TagCategory.order(name: :asc)
  end

  def show
    @tag_category = TagCategory.find(params[:id])
    @tags = @tag_category.tags.select(:id, :name, :description)
  end

  def new
    @tag_category = TagCategory.new
    authorize @tag_category
  end

  def edit
    @tag_category = TagCategory.find(params[:id])
  end

  def create
    @tag_category = TagCategory.new(tag_category_params)
    authorize @tag_category
    if @tag_category.save
      flash[:success] = "Tag category created!"
      redirect_to tag_categories_url
    else
      render 'edit'
    end
  end

  def update
    @tag_category = TagCategory.find(params[:id])
    authorize @tag_category
    if @tag_category.update(tag_category_params)
      flash[:success] = "Tag category updated!"
      redirect_to tag_categories_url
    else
      render 'edit'
    end
  end

  def destroy
    @tag_category = TagCategory.find(params[:id])
    authorize @tag_category
    @tag_category.destroy
    flash[:success] = "Tag category destroyed! I hope it was worth it!"
    redirect_to tag_categories_url
  end

  private
    
    def tag_category_params
      params.require(:tag_category).permit(:name, :instruction, :suggested_max)
    end
end
