class TextbookPagesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

	def new
		@textbook_page = TextbookPage.new
		authorize @textbook_page
		@textbooks = Textbook.all
		# We don't need to see all tags - just those that apply to grammar points
		@tags = TagCategory.find_by_name("Grammar points").tags
	end

	def create
		@textbook_page = TextbookPage.new(textbook_page_params)
		authorize @textbook_page
		if @textbook_page.save
			flash[:success] = "Page created!"
			redirect_to @textbook_page.textbook
		else
			render 'new'
		end
	end

	def show
		@textbook_page = TextbookPage.find(params[:id])
	end

	def edit
		@textbook_page = TextbookPage.find(params[:id])
		authorize @textbook_page
		@textbooks = Textbook.all
		@tags = TagCategory.find_by_name("Grammar points").tags
	end

	def update
		@textbook_page = TextbookPage.find(params[:id])
		authorize @textbook_page
		if @textbook_page.update_attributes(textbook_page_params)
			flash[:success] = "Page updated!"
			redirect_to @textbook_page.textbook
		else
			render 'edit'
		end
	end

	def destroy
		@textbook_page = TextbookPage.find(params[:id])
		authorize @textbook_page
		@textbook = @textbook_page.textbook
		@textbook_page.destroy
		flash[:success] = "Page deleted!"
		redirect_to @textbook
	end

	private

		def textbook_page_params
			params.require(:textbook_page).permit(:textbook_id, :page, :description, :tag_id)
		end
end
