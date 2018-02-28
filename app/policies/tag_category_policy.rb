class TagCategoryPolicy < ApplicationPolicy
  attr_reader :user, :tag_category
  
  def initialize(user, tag_category)
    @user = user
    @tag_category = tag_category
  end
  
  # Tag categories shouldn't change much, if at all - only admins need to tinker with them
  def new?
    user.admin?
  end
  
  def create?
    user.admin?
  end
  
  def edit?
    user.admin?
  end
  
  def update?
    user.admin?
  end
  
  def destroy?
    user.admin? 
  end
end
