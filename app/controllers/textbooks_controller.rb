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
		if @textbook.update_attributes(textbook_params)
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
		if policy(@textbook).update?
			@tags = Tag.all
		end
	end

	def index
		@textbooks = Textbook.all
	end

	private

		def textbook_params
			params.require(:textbook).permit(:name, :additional_info, :level)
		end

end
