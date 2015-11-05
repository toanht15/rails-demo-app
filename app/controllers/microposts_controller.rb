class MicropostsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy
	before_action :set_micropost, only: [:show]
	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to home_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		flash[:success] = "Micropost deleted"
		redirect_to request.referrer || root_url
	end

	#show posts for homepage
	def index
		@microposts = Micropost.paginate(page: params[:page])
		#render 'index'
	end

	#view a post

	def show
		@comment = @micropost.comments.build
		#@comments = @micropost.comments.find_by(id: params[:id]).to_a
		@comments = @micropost.comments.includes(:user)
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content, :picture, :title)
	end

	def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def set_micropost
      @micropost = Micropost.find(params[:id])
    end
end
