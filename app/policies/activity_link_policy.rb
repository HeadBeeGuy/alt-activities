# Currently this is vestigial and isn't called in the ActivityLink controller.
# I wasn't ever able to get this working consistently. The fact that it's a
# class for a join model made authorization more complex and I wasn't able to
# get it to initalize the variables correctly.
# At some point I need to revisit this or perhaps even switch to Cancancan!
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
    user and (user.admin? or user.moderator? or user.activities.include?(inspired_activity))
  end
end
