class JobPostPolicy < ApplicationPolicy
  attr_reader :user, :tag
  
  def initialize(user, job_post)
    @user = user
    @job_post = job_post
  end
  
  # only admins get to play with these until we add another user category
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
