class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # Devise should handle new user creation
  
	def edit
		@user = User.find(params[:id])
	end

  def show
    @user = User.find(params[:id])
  end
  
  def index
		@admins = User.admin
		@moderators = User.moderator
		@normal_users = User.normal
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
      params.require(:username).permit(:username, :email)
    end
end
