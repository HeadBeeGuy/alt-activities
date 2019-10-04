# Authorization applies to the activity that was inspired by another - ideally,
# the user's own activity.
class ActivityLinkPolicy < ApplicationPolicy
  attr_reader :user, :inspired_activity

  def initalize(user, inspired_activity)
    @user = user
    @inspired_activity = inspired_activity
  end

  def new?
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end

  def create?
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end

  def destroy?
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end
end
