class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # Devise should handle new user creation
  
	def edit
		@user = User.find(params[:id])
		authorize @user
	end

	def update
		@user = User.find(params[:id])
		authorize @user
		# only admins can edit a user's e-mail address and username
		# there's probably a more correct way to do this, but I'm kind of surprised it works in the first place!
		unless current_user.admin?
			whitelist = user_params_for_edit
		else
			whitelist = user_params
		end
		if @user.update_attributes(whitelist)
			flash[:success] = "Updated user information!"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:id])
		authorize @user
		@user.destroy
		flash[:success] = "User deleted!"
		redirect_to users_url
	end

  def show
    @user = User.find(params[:id])
    @activities = @user.activities.approved.select(:id, :name, :upvote_count, :short_description)
      .page(params[:page]).order(created_at: :desc)
    @upvotes = Upvote.where(user: @user).includes(:activity)
  end
  
  def index
    unless user_signed_in? && ( current_user.admin? || current_user.moderator? )
      redirect_to contributors_url
    end
		@moderators = User.moderator.select(:id, :username)
		@admins = User.admin.select(:id, :username)
    @all_users = User.select(:id, :username, :activity_count, :created_at)
      .order(created_at: :desc).page(params[:page]).per(80)
  end

	def silence
		@user = User.find(params[:id])
		authorize @user
		@user.set_role(:silenced)
		flash[:success] = "User has been silenced."
		redirect_to @user
	end
  
	def unsilence
		@user = User.find(params[:id])
		authorize @user
		@user.set_role(:normal)
		flash[:success] = "User has been set back to normal."
		redirect_to @user
	end

	def promote
		@user = User.find(params[:id])
		authorize @user
		@user.set_role(:moderator)
		flash[:success] = "User is now a moderator. With great power comes great responsibility!"
		redirect_to @user
	end

	def demote
		@user = User.find(params[:id])
		authorize @user
		@user.set_role(:normal)
		flash[:success] = "User is no longer a moderator."
		redirect_to @user
	end

   private
  
    def user_params
      params.require(:user).permit(:username, :email, :home_country, :location, :bio)
    end

		def user_params_for_edit
      params.require(:user).permit(:home_country, :location, :bio)
    end
end
