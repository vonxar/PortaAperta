class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
    @reply_comment = ReplyComment.new
    @portfolio = Portfolio.find(params[:portfolio_id])
    @comment = current_user.comments.new(comment_params)
    if @comment.save
    # @comment_portfolio = @comment.portfolio
    #投稿に紐づいたコメントを作成
      #通知の作成
      @comment.portfolio.create_notification_comment!(current_user, @comment.id)
    end
  end
  
  def destroy
    @comment = params[:id]
    Comment.find_by(id: params[:id], portfolio_id: params[:portfolio_id]).destroy
  end
  
  
  private
  
  def comment_params
    params.require(:comment).permit(:comment,:rate).merge(portfolio_id: params[:portfolio_id])
  end
  
end
