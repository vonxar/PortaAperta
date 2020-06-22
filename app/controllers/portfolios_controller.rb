class PortfoliosController < ApplicationController
  
  def top
    @portfolios = Portfolio.all
    @p = Portfolio.find_by(user_id: current_user.id)
  end
  
  def show
    @portfolio = Portfolio.find(params[:id])
    @comment = Comment.new
  end
  
  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user_id = current_user.id
    if @portfolio.save
    redirect_to  top_path, notice: "投稿しました"
    else
      render "users/show", alert: '失敗しました'
    end
  end
  
  def edit
      @portfolio = Portfolio.find(params[:id])
      @user = current_user
    if @portfolio.user_id != current_user.id
      render "users/show"
    end
  end
  
  def update
    	 @portfolio = Portfolio.find(params[:id])
    if @portfolio.update(portfolio_params)
    	flash[:notice] ="編集を反映しました。"
        redirect_to top_path(@portfolio.user_id)
    else
    	@user = current_user.id
    	render :edit
    end
  end
  
  def destroy
    @portfolio = Portfolio.find(params[:id])
    @portfolio.destroy
    redirect_to top_path
  end
  
private

  def portfolio_params
  	params.require(:portfolio).permit(:title,:body,:image,:category_id)
  end
  
  
end
