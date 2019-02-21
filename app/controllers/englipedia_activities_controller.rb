class EnglipediaActivitiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @activities = EnglipediaActivity.all
  end

  def show
    @activity = EnglipediaActivity.find(params[:id])
  end
end
