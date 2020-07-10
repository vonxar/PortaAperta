class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @reply_comment = ReplyComment.new
    @portfolio = Portfolio.find(params[:portfolio_id])
    @comment = current_user.comments.new(comment_params)
    if @comment.save
       @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
       #通知の作成
       @comment.portfolio.create_notification_comment!(current_user, @comment.id)
    else
      @portfolio = Portfolio.find(params[:portfolio_id])
     #指定のツイートのコメントを列挙
      @comments = Comment.includes(:user).where(portfolio_id: @portfolio.id).page(params[:page]).per(4)
      @comment = Comment.new
      impressionist(@portfolio, nil, :unique => [:session_hash])
      @page_views = @portfolio.impressionist_count
      @reply_comment = ReplyComment.new
      flash.now[:error] = "失敗"
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
