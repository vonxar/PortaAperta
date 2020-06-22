class CommentsController < ApplicationController
  
  def create
    portfolio = Portfolio.find(params[:portfolio_id])
    comment = current_user.comments.new(comment_params)
    comment.portfolio_id = portfolio.id
    comment.save
    redirect_to portfolio_path(portfolio.id)
  end
  
  def destroy
    Comment.find_by(id: params[:id], portfolio_id: params[:portfolio_id]).destroy
    redirect_to portfolio_path(params[:portfolio_id])
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
