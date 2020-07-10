class LikesController <  ApplicationController
  before_action :authenticate_user!
  
  def create
    @like = current_user.likes.create(portfolio_id: params[:portfolio_id])
    @portfolio = Portfolio.find(params[:portfolio_id])
    #通知の作成
     @portfolio.create_notification_by(current_user)
      respond_to do |format|
        format.html {redirect_to request.referrer}
        format.js
      end
  end
  
  def destroy
    @like = current_user.likes.find_by(portfolio_id: params[:portfolio_id].to_i).destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
    
end