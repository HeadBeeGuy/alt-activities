# this is pinched from http://gavinmiller.io/2016/the-safesty-way-to-constantize/
# previously I was using constantize, but apparently that's a security risk
# if I add any more Commentables, I'll have to add them in here as well
COMMENTABLES = {
  'Activity' => Activity,
  'FrontPagePost' => FrontPagePost,
  'Tag' => Tag
}

class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @comment = Comment.new
    authorize @comment
  end

  def create
    # see comment at top of file
    @commentable = COMMENTABLES.fetch(params[:comment][:commentable_type]).find(params[:comment][:commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.normal! if @comment.user.trusted?
    authorize @comment
    if @comment.save
      if @comment.user.trusted?
        flash[:success] = "Comment posted!"
        redirect_to @comment.commentable
      else
        respond_to do |format|
          format.js
          format.html { # is there a better way to format this in Ruby?
            flash[:success] = "Comment submitted! It will show up once it's approved!"
            redirect_to @comment.commentable }
        end
      end
    else
      flash[:warning] = "Your comment is blank or too long. Can you try revising it?"
      redirect_to @comment.commentable
    end
  end

  def approve
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.unapproved?
      @comment.normal!
      respond_to do |format|
        format.js
        format.html {
          flash[:success] = "Comment approved!"
          redirect_to modqueue_url }
      end
    end
  end

  def unapprove
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.normal? || @comment.solved?
      @comment.unapproved!
      respond_to do |format|
        format.js
        format.html {
          flash[:success] = "Comment returned to the mod queue!"
          redirect_back(fallback_location: root_url) }
      end
    end
  end

  def solve
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.normal?
      @comment.solved!
      respond_to do |format|
        format.js
        format.html {
          flash[:success] = "Marked this issue as solved."
          redirect_back(fallback_location: root_url) }
      end
    end
  end

  def index
    @comments = Comment.normal.or(Comment.solved).page(params[:page]).order(created_at: :desc)
  end

  def destroy
    @comment = Comment.find(params[:id])
		authorize @comment
		@comment.destroy
    respond_to do |format|
      format.js
      format.html {
        flash[:success] = "Deleted comment."
        redirect_back(fallback_location: root_url) }
    end
  end

    private
      
      def comment_params
        params.require(:comment).permit(:content, :commentable_type, :commentable_id)
      end
end
