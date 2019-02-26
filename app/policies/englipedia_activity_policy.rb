
class EnglipediaActivityPolicy < ApplicationPolicy
  attr_reader :user, :englipedia_activity
  
  def initialize(user, englipedia_activity)
    @user = user
    @englipedia_activity = englipedia_activity
  end

  # only mods and admins can see or alter Englipedia Activities
  
  def new?
    user.admin? or user.moderator?
  end
  
  def create?
    user.admin? or user.moderator?
  end
  
  def index?
    user.admin? or user.moderator?
  end

  def show?
    user.admin? or user.moderator?
  end

  def edit?
    user.admin? or user.moderator?
  end
  
  def update?
    user.admin? or user.moderator?
  end
  
  def convert?
    user.admin? or user.moderator?
  end
  
  def destroy?
    user.admin? or user.moderator? 
  end
end
