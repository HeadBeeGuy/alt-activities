
class ActivitySearchesController < ApplicationController

  def show
    if params[:search]
      @activities = Activity.where('name LIKE ? OR short_description LIKE ? OR ' +
                                   'long_description LIKE ?', 
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
