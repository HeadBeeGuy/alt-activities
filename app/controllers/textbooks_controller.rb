class TextbooksController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

	def new
		@textbook = Textbook.new
		authorize @textbook
	end

	def create
		@textbook = Textbook.new(textbook_params)
		authorize @textbook
		if @textbook.save
			flash[:success] = "Textbook created!"
			redirect_to textbooks_url
		else
			render 'edit'
		end
	end

	def edit
		@textbook = Textbook.find(params[:id])
		authorize @textbook
	end

	def update
		@textbook = Textbook.find(params[:id])
		authorize @textbook
		if @textbook.update(textbook_params)
			flash[:success] = "Textbook updated!"
			redirect_to @textbook
		else
			render 'edit'
		end
	end

	def destroy
		@textbook = Textbook.find(params[:id])
		authorize @textbook
		@textbook.destroy
		flash[:success] = "Textbook deleted."
		redirect_to textbooks_url
	end

	def show
		@textbook = Textbook.find(params[:id])
		@pages = @textbook.textbook_pages.order(page: :asc).includes(:tag)
		if policy(@textbook).update?
			@tags = Tag.select(:id, :name).order(name: :asc)
		end
	end

	def index
		@es_textbooks = Textbook.ES.order(year_published: :desc, name: :asc)
		@jhs_textbooks = Textbook.JHS.order(year_published: :desc, name: :asc)
		@hs_textbooks = Textbook.HS.order(year_published: :desc, name: :asc)
	end

	private

		def textbook_params
			params.require(:textbook).permit(:name, :additional_info, :level, :year_published)
		end

end
