class ReplyCommentsController < ApplicationController
  
   def create
    @comment = Comment.find(params[:comment_id])
    @reply_comment = ReplyComment.new(reply_comment_params)
    if @reply_comment.save
      @comment.reply_comment_id = @reply_comment.id
      @comment.save
      @portfolio = Portfolio.find(params[:portfolio_id])
    #   @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
      @comments = @portfolio.comments.includes(:user).page(params[:page]).per(4)
       respond_to do |format|
       format.html
       format.js
       end
       #通知の作成
      @reply_comment.comment.portfolio.create_notification_reply_comment!(current_user, @comment.id, @reply_comment.id)
      
      @reply_comment = ReplyComment.new
    else
      @portfolio = Portfolio.find(params[:portfolio_id])
     #指定のツイートのコメントを列挙
      @comments = Comment.includes(:user).where(portfolio_id: @portfolio.id).page(params[:page]).per(4)
      @comment = Comment.new
      impressionist(@portfolio, nil, :unique => [:session_hash])
      @page_views = @portfolio.impressionist_count
    
      @reply_comment = ReplyComment.new
      flash.now[:alert] = '失敗'
      render 'portfolios/show'
    end
    
   end
   
   def destroy
     @reply = params[:id]
     ReplyComment.find_by(id: params[:id],comment_id: params[:comment_id]).destroy
      @portfolio = Portfolio.find(params[:portfolio_id])
      @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
      @reply_comment = ReplyComment.new
   end
   
    private
  
  def reply_comment_params
    params.require(:reply_comment).permit(:reply_comment).merge(comment_id: params[:comment_id],user_id: current_user.id)
  end
end
