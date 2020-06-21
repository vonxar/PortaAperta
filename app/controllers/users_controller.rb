class UsersController < ApplicationController
  
  def show
    @portfolio = Portfolio.new
    @user_portfolios = Portfolio.where(user_id: current_user.id)
  end
  
end
