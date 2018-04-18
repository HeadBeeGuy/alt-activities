class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  # Devise should handle new user creation
  
	def edit
		@user = User.find(params[:id])
		authorize @user
	end

	def update
		@user = User.find(params[:id])
		#may need to create another whitelist filter for non-admins
		authorize @user
		if @user.update_attributes(user_params)
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
      params.require(:user).permit(:username, :email, :home_country, :location, :bio)
    end
end
