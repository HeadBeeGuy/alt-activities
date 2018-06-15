class FrontPagePostPolicy < ApplicationPolicy
  attr_reader :user, :tag
  
  def initialize(user, front_page_post)
    @user = user
    @front_page_post = front_page_post
  end
  
  # only admins get to play with these, at this point in time
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
