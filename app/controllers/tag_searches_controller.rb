
class TagSearchesController < ApplicationController

  def new
    @tag_categories = TagCategory.all.includes(:tags)
    # @tags = Tag.all
  end

  def show
    # @unfiltered_tag_ids = params[:tag][:tag_ids]
    # @tag_ids = @unfiltered_tag_ids.map{ |x| x.to_i }.delete_if{ |x| x < 1 }
    # @searched_tags = Tag.find(@tag_ids)

    # # this appears to lead to an N+1 query, probably since it returns an array
    # # and not an ActiveRecordRelation
    # @activities = Activity.find_with_all_tags(@tag_ids, 10)

    @tags = params[:tag_ids]

    activities = Activity.joins(:taggings)
                .where({status: 1, taggings: { tag_id: @tags}})
                .group('activities.id')
                .having("COUNT(*) >= ?", @tags.size)
                .select(:name, :created_at, :updated_at, :id, :short_description, :time_estimate, :upvote_count)
                .order(params[:order])

    if activities
      render json: activities.to_json(include: :taggings)
    else
      render json: activities.errors
    end
  end

end
