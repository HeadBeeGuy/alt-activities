class TaggingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tagging = Tagging.new
    authorize @tagging
  end

  def create
    @tagging = Tagging.new(tagging_params)
    authorize @tagging
    
    if @tagging.save
      respond_to do |format|
        format.js
        format.html {
          flash[:success] = "Added tag!"
          redirect_to @tagging.activity }
      end
    end
  end

  def destroy
    @tagging = Tagging.find(params[:id])
    authorize @tagging
    @tagging.destroy
    respond_to do |format|
      format.js
      format.html {
        flash[:success] = "Tag deleted."
        redirect_to @tagging.activity }
    end

  end

  private

    def tagging_params
      params.require(:tagging).permit(:activity_id, :tag_id)
    end

end
