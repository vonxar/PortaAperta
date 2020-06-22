class FavoritesController < ApplicationController
  
  def create
    @favorite = current_user.favorites.create(portfolio_id: params[:portfolio_id])
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def destroy
    @favorite = current_user.favorites.find_by(portfolio_id: params[:portfolio_id]).destroy
    @portfolio = Portfolio.find(params[:portfolio_id])
  end
  
end
