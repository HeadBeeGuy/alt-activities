class TextbookPageLinkPolicy < ApplicationPolicy
  attr_reader :user, :textbook_page_link

  def initialize(user, textbook_page_link)
    @user = user
    @activity = textbook_page_link.activity
  end

  def create?
    user and (user.admin? or user.moderator? or user.activities.include?(@activity))
  end

  def destroy?
    user and (user.admin? or user.moderator? or user.activities.include?(@activity))
  end
end
