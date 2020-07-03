class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @portfolio = Portfolio.new
    @user_portfolios = Portfolio.where(user_id: current_user.id).page(params[:page]).per(4)
    @favorites = current_user.favorite_portfolios.includes(:user).page(params[:page]).per(4)
  end
  
  def edit
       @user = User.find(params[:id])
    if @user.id != current_user.id
       redirect_to user_path(current_user.id)
    end
  end
  
  def update
    	@user = User.find(params[:id])
    if @user.update(user_params)
    	redirect_to user_path(@user.id), notice: "プロフィールを更新しました。"
    else
    	render :edit
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
end
