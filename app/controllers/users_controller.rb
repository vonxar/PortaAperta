class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_only, only: %i[edit update]
  before_action :check_guest, only: %i[update destroy]
  
  def index
    @users = User.all
  end
  
  def show
    @chat = 0
    @portfolio = Portfolio.new
    @user = User.find(params[:id])
    if current_user.id == @user.id
     @user_portfolios = Portfolio.where(user_id: current_user.id).page(params[:page]).per(4)
     @favorites = current_user.favorite_portfolios.includes(:user).page(params[:page]).per(4)
    else
      @user_portfolios = Portfolio.where(user_id: @user.id).page(params[:page]).per(4)
      @favorites = @user.favorite_portfolios.includes(:user).page(params[:page]).per(4)
      if !Room.where(first_user_id: current_user.id,second_user_id: @user.id).present? && !Room.where(first_user_id: @user.id, second_user_id: current_user.id).present?
        @chat = nil
      elsif  Room.where(first_user_id: current_user.id,second_user_id: @user.id).present?
        @room = Room.where(first_user_id: current_user.id)
      elsif Room.where(first_user_id: @user.id, second_user_id: current_user.id).present?
        @room = Room.where(second_user_id: current_user.id)
      end
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
    	redirect_to user_path(@user.id), notice: "プロフィールを更新しました。"
    else
      flash.now[:alert] = "失敗しました。"
    	render :edit
    end
  end
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
  
  def user_only
    @user = User.find(params[:id])
    if @user.id != current_user.id
       redirect_to user_path(current_user.id), alert: "アクセスできません"
    end
  end
  
  def check_guest
    if current_user.email == 'guest@example.com'
      redirect_to top_path, alert: 'ゲストユーザーの変更・削除はできません。'
    end
  end
  
end
