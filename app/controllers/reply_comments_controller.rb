class ReplyCommentsController < ApplicationController
  
   def create
    @comment = Comment.find(params[:comment_id])
    @reply_comment = ReplyComment.new(reply_comment_params)
    if @reply_comment.save
      @comment.reply_comment_id = @reply_comment.id
      @comment.save
      redirect_to portfolio_path(@comment.portfolio_id)
    else
      flash[alert] = '失敗'
      render 'portfolios/show'
    end
    
   end
   
   def destroy
       ReplyComment.find_by(id: params[:id],comment_id: params[:comment_id]).destroy
     redirect_to portfolio_path(params[:portfolio_id])
   end
   
    private
  
  def reply_comment_params
    params.require(:reply_comment).permit(:reply_comment).merge(comment_id: params[:comment_id],user_id: current_user.id)
  end
end
