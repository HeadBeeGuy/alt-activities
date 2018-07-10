class CommentPolicy < ApplicationPolicy
  attr_reader :user, :comment
  
  def initialize(user, comment)
    @user = user
    @comment = comment
  end
  
  # silenced users can't write comments
  def new?
    user and ( not user.silenced? )
  end
  
  def create?
    user and ( not user.silenced? )
  end
  
  def edit?
    user.admin? or ( user.comments.include?(comment) and not user.silenced? )
  end
  
  def update?
    user.admin? or ( user.comments.include?(comment) and not user.silenced? )
  end
  
  def delete?
    user.admin? or user.moderator? or (user.comments.include?(comment))
  end

  def destroy?
    user.admin? or user.moderator? or (user.comments.include?(comment))
  end
  
  def show?
    ( not comment.unapproved? ) or (user and (user.admin? or user.moderator?))
  end

  def approve?
    user.admin? or user.moderator?
  end

  def unapprove?
    user.admin? or user.moderator?
  end
  
  def solve?
    comment.normal? and (user.admin? or user.moderator? or 
      ( comment.commentable_type == "Activity" and user.activities.include?(comment.commentable) and 
      not user.silenced? ))
  end
  
end
