# Right now the only time this is called is in the destroy method.
# Apparently this wasn't working when ActivityLinks were first created, so 
# creation permission checking is handled directly in the controller.

class ActivityLinkPolicy < ApplicationPolicy
  attr_reader :user, :activity_link

  def initalize(user, activity_link)
    @user = user
    @activity_link = activity_link
    @inspired_activity = @activity_link.inspired
  end

  def new?
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end

  def create?
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end

  def destroy?
    user and (user.admin? or user.moderator? or user.activities.include?(@inspired_activity))
  end
end
