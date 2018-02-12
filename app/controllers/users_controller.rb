class UsersController < ApplicationController
  
  # Devise should handle new user creation
  
  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end
  
   private
  
    def user_params
      params.require(:username).permit(:username, :email)
    end
end
