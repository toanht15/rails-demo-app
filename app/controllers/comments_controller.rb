class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create]
	before_action :correct_user
	def create
		@comment = current_user.comments.build(comment_params)
		@comment.micropost = Micropost.find(params[:micropost_id])
		if @comment.save
			flash[:success] = "Comment created!"
			redirect_to request.referrer || root_url
		else
			@micropost = Micropost.find(params[:micropost_id])
			render 'microposts/show'
		end
	end

	private

	def comment_params
		params.require(:comment).permit(:content)
	end

	def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
	
end
