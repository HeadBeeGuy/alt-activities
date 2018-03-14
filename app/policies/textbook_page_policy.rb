class TextbookPagePolicy < ApplicationPolicy
  attr_reader :user, :textbook_page
  
  def initialize(user, textbook_page)
    @user = user
    @textbook_page = textbook_page
  end
  
	# textbook pages should have the same policy as textbooks - perhaps there's a way to inherit?
  def new?
    user and (user.admin? or user.moderator?)
  end
  
  def create?
    user and (user.admin? or user.moderator?)
  end
  
  def edit?
    user and (user.admin? or user.moderator?)
  end
  
  def update?
    user and (user.admin? or user.moderator?)
  end
  
  def delete?
    user and (user.admin? or user.moderator?)
  end
  
  def destroy?
    user and (user.admin? or user.moderator?) 
  end
end
