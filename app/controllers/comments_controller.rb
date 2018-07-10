class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def new
    @comment = Comment.new
    authorize @comment
  end

  def create
    # awkward! there's probably a better way to find the commentable item
    @commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    authorize @comment
    if @comment.save
      flash[:success] = "Comment submitted! It will show up once it's approved!"
      redirect_to @comment.commentable
    else
      render 'edit'
    end
  end

  def approve
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.unapproved?
      @comment.normal!
      flash[:success] = "Comment approved!"
      redirect_to modqueue_url
    end
  end

  def unapprove
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.normal? || comment.solved?
      @comment.unapproved!
      flash[:success] = "Comment returned to the mod queue!"
      redirect_back(fallback_location: root_url)
    end
  end

  def solve
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.normal?
      @comment.solved!
      flash[:success] = "Marked this issue as solved!"
      redirect_to @comment.commentable
    end
  end

  def index
    @comments = Comment.normal.or(Comment.solved).page(params[:page]).order(created_at: :desc)
  end

  def destroy
    @comment = Comment.find(params[:id])
		authorize @comment
		@comment.destroy
		flash[:success] = "Comment deleted!"
		redirect_back(fallback_location: root_url)
  end

    private
      
      def comment_params
        params.require(:comment).permit(:content, :commentable_type, :commentable_id)
      end
end
