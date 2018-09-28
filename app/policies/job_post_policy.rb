class JobPostPolicy < ApplicationPolicy
  attr_reader :user, :tag
  
  def initialize(user, job_post)
    @user = user
    @job_post = job_post
  end
  
  # job_poster is a special kind of account that gets to post and update their own listings
  # currently I'll limit this to the site's primary sponsor only, but this can be changed if necessary
  def new?
    user.admin? or user.job_poster?
  end
  
  def create?
    user.admin? or user.job_poster?
  end
  
  def edit?
    user.admin? or (user.job_poster? and user.job_posts.include?(@job_post))
  end
  
  def update?
    user.admin? or (user.job_poster? and user.job_posts.include?(@job_post))
  end
  
  def delete?
    user.admin? or (user.job_poster? and user.job_posts.include?(@job_post))
  end
  
  def destroy?
    user.admin? or (user.job_poster? and user.job_posts.include?(@job_post))
  end
end
