class FrontPagePostsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]

	def new
		@front_page_post = FrontPagePost.new
		authorize @front_page_post
	end

	def create
		@front_page_post = FrontPagePost.new(front_page_post_params)
		authorize @front_page_post
		@front_page_post.user = current_user
		if @front_page_post.save
			flash[:success] = "Posted!"
			redirect_to root_url
		else
			render 'edit'
		end
	end

	def edit
		@front_page_post = FrontPagePost.find(params[:id])
		authorize @front_page_post
	end

	def update
		@front_page_post = FrontPagePost.find(params[:id])
		authorize @front_page_post
		if @front_page_post.update_attributes(front_page_post_params)
			flash[:success] = "Updated the post!"
			redirect_to @front_page_post
		else
			render 'edit'
		end
	end

	def show
		@front_page_post = FrontPagePost.find(params[:id])
	end

	def index
		@front_page_posts = FrontPagePost.all.select(:id, :title)
	end

	def destroy
		@front_page_post = FrontPagePost.find(params[:id])
		authorize @front_page_post
		@front_page_post.destroy
		flash[:success] = "Post removed."
		redirect_to root_url
	end
	
	private
	  def front_page_post_params
			params.require(:front_page_post).permit(:title, :excerpt, :content)
		end
end
