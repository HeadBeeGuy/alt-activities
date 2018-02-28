class TagPolicy < ApplicationPolicy
  attr_reader :user, :tag
  
  def initialize(user, tag)
    @user = user
    @tag = tag
  end
  
  # In general, tags should be created sparingly and not by normal users
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
  
  def delete?
    user.admin?
  end
  
  def destroy?
    user.admin? 
  end
end
