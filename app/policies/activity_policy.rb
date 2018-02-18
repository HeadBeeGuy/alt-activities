class ActivityPolicy < ApplicationPolicy
  attr_reader :user, :activity
  
  def initialize(user, activity)
    @user = user
    @activity = activity
  end
  
  # if you're silenced, you shouldn't be able to trouble us with activities!
  def create?
    not user.silenced?
  end
  
  def edit?
    user.admin? or (user.activities.include?(activity))
  end
  
  def update?
    user.admin? or (user.activities.include?(activity))
  end
  
  def destroy?
    user.admin? or (user.activities.include?(activity))
  end
end