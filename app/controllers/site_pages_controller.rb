class SitePagesController < ApplicationController

  def about
  end
  
  def es
    # I hope this query isn't too brittle
    # Would I be an ogre if I accessed by id? this will probably be a frequently viewed page
    # but if the id ever changed, this page would break!
    @activites = Tag.find_by_short_name("ES").activities
  end
  
  def jhs
    @activites = Tag.find_by_short_name("JHS").activities
  end
  
  def grammar
    @tags = TagCategory.find_by_name("Grammar points").tags
  end
end
