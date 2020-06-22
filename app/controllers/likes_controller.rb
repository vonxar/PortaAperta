class LikesController <  ApplicationController
  
  def create
    @like = current_user.likes.create(portfolio_id: params[:portfolio_id])
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
  
  def destroy
    @like = current_user.likes.find_by(portfolio_id: params[:portfolio_id].to_i).destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
    
end