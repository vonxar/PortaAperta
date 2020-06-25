class PortfoliosController < ApplicationController
  
  def top
    @portfolios = Portfolio.all
    if params[:tag_name]
      @portfolios = Portfolio.tagged_with("#{params[:tag_name]}")
    end
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
        redirect_to top_path
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
  
  def search
    @users = User.where('name LIKE(?)', "%#{params[:keyword]}%") #paramsとして送られてきたkeyword（入力された語句）で、Userモデルのnameカラムを検索し、その結果を@usersに代入する
    # @portfolios = Portfolio.where('id LIKE(?)', "%#{params[:keyword]}%")
    render json: @users
  end
  
private

  def portfolio_params
  	params.require(:portfolio).permit(:title,:body,:image,:category_id,:tag_list)
  end
  
  
end
