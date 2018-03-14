class TextbookPolicy < ApplicationPolicy
  attr_reader :user, :textbook
  
  def initialize(user, textbook)
    @user = user
    @textbook = textbook
  end
  
  # for the time being, both admins and moderators can make and alter textbooks
	# if it ever gets out of hand, we could move it to admins only
  def new?
    user and (user.admin? or user.moderator?)
  end
  
  def create?
    user and (user.admin? or user.moderator?)
  end
  
  def edit?
    user and (user.admin? or user.moderator?)
  end
  
  def update?
    user and (user.admin? or user.moderator?)
  end
  
  def delete?
    user and (user.admin? or user.moderator?)
  end
  
  def destroy?
    user and (user.admin? or user.moderator?) 
  end
end
