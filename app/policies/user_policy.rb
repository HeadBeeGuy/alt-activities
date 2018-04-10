class UserPolicy < ApplicationPolicy
	# This might be a bit confusing, since usually Pundit is being called on an object other than "User"
  attr_reader :user, :target_user
  
  def initialize(user, target_user)
    @user = user
    @target_user = target_user
  end
  
  # leaving creation to Devise 
	def edit?
    user and (user.admin? or user == target_user)
  end
  
  def update?
    user and (user.admin? or user == target_user)
  end
  
  def delete?
    user.admin? and user != target_user
  end
  
  def destroy?
    user.admin? 
  end

	# moderators can't use silencing to demote each other
	def silence?
		user and ( user.admin? or user.moderator? ) and target_user.normal?
	end

	def unsilence?
		user and ( user.admin? or user.moderator? ) and target_user.silenced?
	end

	def promote?
		user and user.admin? and target_user.normal?
	end

	def demote?
		user and user.admin? and target_user.moderator?
	end
end
