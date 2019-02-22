class EnglipediaActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @activities = EnglipediaActivity.all
  end

  def show
    @activity = EnglipediaActivity.find(params[:id])
  end

  def edit
    @activity = EnglipediaActivity.find(params[:id])
  end

  def update
    @activity = EnglipediaActivity.find(params[:id])
    if @activity.update_attributes(englipedia_activity_params)
      flash[:success] = "Updated activity info."
      redirect_to @activity
    else
      render 'edit'
    end
  end

  private
    def englipedia_activity_params
      params.require(:englipedia_activity).permit(:title, :author,
                                                  :submission_date,
                                                  :estimated_time, :speaking,
                                                  :listening, :reading,
                                                  :writing, :description)
    end
    
end
