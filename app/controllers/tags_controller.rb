class TagsController < ApplicationController
  
  def new
  end
  
  def edit
  end
  
  def show
    @tag = Tag.find(params[:id])
  end
  
  def index
    @tags = Tag.all
  end
  
  private
  
    def tag_params
      params.require(:activity).permit(:short_name, :long_name, :description)
    end
  
end
