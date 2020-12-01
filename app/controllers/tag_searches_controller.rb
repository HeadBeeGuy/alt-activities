
class TagSearchesController < ApplicationController

  def new
    @tag_categories = TagCategory.all
  end

  def show
    @unfiltered_tag_ids = params[:tag][:tag_ids]
    @tag_ids = @unfiltered_tag_ids.map{ |x| x.to_i }.delete_if{ |x| x < 1 }
    @searched_tags = Tag.find(@tag_ids)

    # this appears to lead to an N+1 query, probably since it returns an array
    # and not an ActiveRecordRelation
    @activities = Activity.find_with_all_tags(@tag_ids, 10)
  end

end
