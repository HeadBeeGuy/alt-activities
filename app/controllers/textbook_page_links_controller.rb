class TextbookPageLinksController < ApplicationController
  def create
    @activity = Activity.find(params[:textbook_page_link][:activity_id])
    @textbook_page = TextbookPage.find(params[:textbook_page_link][:textbook_page_id])
    @textbook_page_link = TextbookPageLink.new(activity: @activity,
                                               textbook_page: @textbook_page)
    authorize @textbook_page_link
    if @textbook_page_link.save
      flash[:success] = "The activity is now linked to this page!"
    else
      flash[:warning] = "Something went wrong and the activity couldn't be linked."
    end
    redirect_to textbook_page_url(@textbook_page)
  end

  def destroy
    @textbook_page_link = TextbookPageLink.find(params[:id])
    @activity = @textbook_page_link.activity
    authorize @textbook_page_link
    @textbook_page_link.destroy
    flash[:success] = "Removed the link."
    redirect_to activity_url(@activity)
  end

  private

  def textbook_page_link_params
    params.require(:textbook_page_link).permit(:activity_id, :textbook_page_id)
  end
end
