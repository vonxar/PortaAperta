class UsersController < ApplicationController
  
  def show
    @portfolio = Portfolio.new
    @user_portfolios = Portfolio.where(user_id: current_user.id)
    @favorites = current_user.favorite_portfolios.includes(:user)
  end
  
end
