
class ActivitySearchesController < ApplicationController

  def show
    if params[:search]
      @activities = Activity.text_search(params[:search])
                     .approved.select(:id, :name, :upvote_count, :short_description)
                     .limit(20)
      @tags = Tag.text_search(params[:search]).limit(10)
    else
      @activities = nil
    end
  end

end
