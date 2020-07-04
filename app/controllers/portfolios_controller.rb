class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :portfolio_Validation ,only: %i[edit destroy]
  
  
  def top
    @portfolios = Portfolio.order("created_at DESC").page(params[:page]).per(6)
    @tags = ActsAsTaggableOn::Tag.order('taggings_count Desc')
    if params[:tag_name]
      @portfolios = Portfolio.tagged_with("#{params[:tag_name]}").page(params[:page]).per(6)
    end
  end
  
  def index
   @portfolios =Portfolio.find(Impression.group(:impressionable_id).order('count(impressionable_id) desc').limit(3).pluck(:impressionable_id))
  end
  
  def new
    @portfolio = Portfolio.new
  end
  
  def show
    @portfolio = Portfolio.find(params[:id])
    @comment = Comment.new
    impressionist(@portfolio, nil, :unique => [:session_hash])
    @page_views = @portfolio.impressionist_count
    
  end
  
  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user_id = current_user.id
    if @portfolio.save
    redirect_to  top_path, notice: "投稿しました"
    else
      @user_portfolios = Portfolio.where(user_id: current_user.id)
      @favorites = current_user.favorite_portfolios.includes(:user)
      flash.now[:alert] = '失敗しました'
      render "users/show"
    end
  end
  
  def edit
      @user = current_user
    if @portfolio.user_id != current_user.id
      render "users/show"
    end
  end
  
  def update
       @portfolio = Portfolio.find(params[:id])
    	 owned_tag_list = [(params[:portfolio][:tag_list])]
    	 @portfolio.tag_list.add(owned_tag_list)
    	 @portfolio.save
    if @portfolio.update(portfolio_params)
        redirect_to top_path, notice: "編集を反映しました。"
    else
    	@user = current_user.id
    	flash[:alert] = "失敗しました。"
    	render :edit
    end
  end
  
  def destroy
    @portfolio.destroy
    redirect_to top_path
  end
  
  def search
    @path = Rails.application.routes.recognize_path(request.referer)
   if @path[:controller] == "portfolios" && @path[:action] == "top"
      @path = true
   end
    if params[:word].blank?
        word =  params[:portfolio][:keyword]
          if word == 'visit'
            @word = "PV"
          elsif word == 'ranking_likes'
            @word = "いいね"
          elsif word == 'ranking_comment'
            @word = "コメント"
          end
        selection = params[:portfolio][:keyword]
        @portfolios = Portfolio.sort(selection)
    else
      # @users = User.where('name LIKE(?)', "%#{params[:word]}%") #paramsとして送られてきたword（入力された語句）で、Userモデルのnameカラムを検索し、その結果を@usersに代入する
      @portfolios = Portfolio.where('title LIKE(?)', "%#{params[:word]}%")
      render json: @portfolios
      # render json: @users
    end
  end
  
  
  
private

  def portfolio_params
  	params.require(:portfolio).permit(:title,:body,:image,:category_id,:tag_list)
  end
  
  def portfolio_Validation
    @portfolio = Portfolio.find(params[:id])
    if  @portfolio.user_id != current_user.id
      redirect_to user_path(current_user), alert: "アクセスできません"
    end
  end
  
end
