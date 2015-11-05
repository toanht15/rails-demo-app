class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create]
	before_action :get_micropost, only:[:create]
	before_action :check_follow, only:[:create]
	def create
		@comment = current_user.comments.build(comment_params)
		@comment.micropost = Micropost.find(params[:micropost_id])
		
		if @comment.save
			flash[:success] = "Comment created!"
			redirect_to request.referrer || root_url
		else

			@comments = @micropost.comments.includes(:user)
			render 'microposts/show'
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:content, :user_id, :micropost_id)
	end

	def correct_user
		@comment = current_user.comments.find_by(id: params[:id])
		redirect_to root_url if @comment.nil?
	end

	def get_micropost
		@micropost = Micropost.find(params[:micropost_id])
	end   
	
	def check_follow
		if current_user != @micropost.user
			following_ids = current_user.active_relationships.pluck(:followed_id)
			if !following_ids.include? @micropost.user.id
				flash[:danger] = "Please follow this user to comment"
				redirect_to :back
			end
		end
	end
end
