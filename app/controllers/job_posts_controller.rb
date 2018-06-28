class JobPostsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show]

	def new
		@job_post = JobPost.new
		authorize @job_post
	end

	def create
		@job_post = JobPost.new(job_post_params)
		authorize @job_post
		@job_post.user = current_user
		if @job_post.save
			flash[:success] = "New job post created!"
			redirect_to job_posts_url
		else
			render 'edit'
		end
	end

	def edit
		@job_post = JobPost.find(params[:id])
	end

	def update
		@job_post = JobPost.find(params[:id])
		authorize @job_post
		if @job_post.update_attributes(job_post_params)
			flash[:success] = "Post updated!"
			redirect_to @job_post
		else
			render 'edit'
		end
	end

	def show
		@job_post = JobPost.find(params[:id])
	end

	def index
		@job_posts = JobPost.all.order(created_at: :desc)
	end

	def destroy
		@job_post = JobPost.find(params[:id])
		authorize @job_post
		@job_post.destroy
		flash[:success] = "Post removed."
		redirect_to job_posts_url
	end

	private
	  def job_post_params
			params.require(:job_post).permit(:title, :external_url, :content, :priority, :company_logo, post_images: [])
		end
end
