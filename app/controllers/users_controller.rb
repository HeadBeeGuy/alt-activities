class UsersController < ApplicationController
  
   private
  
    # is this necessary given what Devise is doing?
    def user_params
      params.require(:username).permit(:username, :email) #might need password stuff?
    end
end
