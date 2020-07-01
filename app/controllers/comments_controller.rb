class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @portfolio = Portfolio.find(params[:portfolio_id])
    @comment = current_user.comments.new(comment_params)
    @comment.portfolio_id = @portfolio.id
    @comment.save
  end
  
  def destroy
    @comment = params[:id]
    Comment.find_by(id: params[:id], portfolio_id: params[:portfolio_id]).destroy
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment,:rate)
  end
end
