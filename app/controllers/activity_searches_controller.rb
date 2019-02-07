
class ActivitySearchesController < ApplicationController

  def show
    if params[:search]
      @activities = Activity.where('name ILIKE ? OR short_description ILIKE ? OR ' +
                                   'long_description ILIKE ?', 
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%",
                                   "%#{params[:search]}%")
                     .approved.select(:id, :name, :upvote_count, :short_description)
                     .limit(20).order(upvote_count: :desc)
    else
      @activities = nil
    end
  end
end
