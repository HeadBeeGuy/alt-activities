class TaggingPolicy < ApplicationPolicy
  attr_reader :user, :tagging
  
  def initialize(user, tagging)
    @user = user
    @tagging = tagging
  end
  
  # admins and moderators can edit taggings, as well as an activity's owner
  def new?
    user.admin? or user.moderator? or user.activities.include?(@tagging.activity)
  end
  
  def create?
    user.admin? or user.moderator? or user.activities.include?(@tagging.activity)
  end
  
  def delete?
    user.admin? or user.moderator? or user.activities.include?(@tagging.activity)
  end
  
  def destroy?
    user.admin? or user.moderator? or user.activities.include?(@tagging.activity)
  end
end
