class ActivityPolicy < ApplicationPolicy
  attr_reader :user, :activity
  
  def initialize(user, activity)
    @user = user
    @activity = activity
  end
  
  # this is getting a bit complex - maybe scopes would express these concepts better?
  
  # if you're silenced, you shouldn't be able to trouble us with activities!
  def new?
    not user.silenced?
  end
  
  def create?
    not user.silenced?
  end
  
  def edit?
    user.admin? or user.moderator? or (user.activities.include?(activity))
  end
  
  def update?
    user.admin? or user.moderator? or (user.activities.include?(activity))
  end
  
  def destroy?
    user.admin? or (user.activities.include?(activity))
  end
  
  def approve?
    user and (user.admin? or user.moderator?)
  end
  
  def unapprove?
    user and (user.admin? or user.moderator?)
  end
  
  def show?
    activity.approved? or (user and (user.admin? or user.moderator? or user.activities.include?(activity)))
  end

  def delete_attached_document?
    user.admin? or (user.activities.include?(activity))
  end
end
