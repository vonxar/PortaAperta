class PortfoliosController < ApplicationController
  before_action :authenticate_user!
  before_action :portfolio_Validation ,only: :edit
  
  
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
   unless request.post? != true
    if params[:comment_number] == "0"
      @replyc_comment = ReplyComment.new
      @portfolio = Portfolio.find(params[:portfolio_id])
      @comment = current_user.comments.new(comment_params)
        if @comment.save
          @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
          # @comment_portfolio = @comment.portfolio
          #投稿に紐づいたコメントを作成
          #通知の作成
          @comment.portfolio.create_notification_comment!(current_user, @comment.id)
        else
          @portfolio = Portfolio.find(params[:portfolio_id])
          #指定のツイートのコメントを列挙
          @comments = Comment.includes(:user).where(portfolio_id: @portfolio.id).page(params[:page]).per(4)
          @comment = Comment.new
          impressionist(@portfolio, nil, :unique => [:session_hash])
          @page_views = @portfolio.impressionist_count
                
          @reply_comment = ReplyComment.new
          flash.now[:error] = "失敗"
        end
        
    elsif   params[:reply] == "1"
            @comment = Comment.find(params[:comment_id])
            @reply_comment = ReplyComment.new(reply_comment_params)
          if @reply_comment.save
             @comment.reply_comment_id = @reply_comment.id
              @comment.save
              @portfolio = Portfolio.find(params[:portfolio_id])
              #   @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
              @comments = @portfolio.comments.includes(:user).page(params[:page]).per(4)
               respond_to do |format|
               format.html
               format.js
              end
                                 #通知の作成
              @reply_comment.comment.portfolio.create_notification_reply_comment!(current_user, @comment.id, @reply_comment.id)
              @reply_comment = ReplyComment.new
          else
              @portfolio = Portfolio.find(params[:portfolio_id])
            #指定のツイートのコメントを列挙
              @comments = Comment.includes(:user).where(portfolio_id: @portfolio.id).page(params[:page]).per(4)
              @comment = Comment.new
              impressionist(@portfolio, nil, :unique => [:session_hash])
              @page_views = @portfolio.impressionist_count
                              
              @reply_comment = ReplyComment.new
              flash.now[:error] = '失敗'
              render 'portfolios/show'
          end
    end
   end
      
      
   @portfolio = Portfolio.find(params[:id])
     #指定のツイートのコメントを列挙
   @comments = Comment.includes(:user).where(portfolio_id: @portfolio.id).page(params[:page]).per(4)
    respond_to do |format|
    format.html
    format.js
    end
    
   @comment = Comment.new
   impressionist(@portfolio, nil, :unique => [:session_hash])
   @page_views = @portfolio.impressionist_count
   @reply_comment = ReplyComment.new
  end
  
  
  
  
  
  
  
  
  def create
    @portfolio = Portfolio.new(portfolio_params)
    @portfolio.user_id = current_user.id
    if @portfolio.save
     redirect_to  top_path, notice: "投稿しました"
    elsif params[:error_post] == "0"
      render new_portfolio_path
    elsif params[:error_post] == "1"
      @user = current_user
      @user_portfolios = Portfolio.where(user_id: current_user.id).page(params[:page]).per(4)
      @favorites = current_user.favorite_portfolios.includes(:user).page(params[:page]).per(4)
      flash.now[:alert] = "入力が適切ではありません"
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
    	flash.now[:alert] = "失敗しました。"
    	render :edit
    end
  end
  
  def destroy
    if params[:portfolio_destroy] == "1"
        @portfolio = Portfolio.find(params[:id])
        if  @portfolio.user_id != current_user.id
         redirect_to user_path(current_user), alert: "アクセスできません"
        end
        @portfolio.destroy
        redirect_to top_path
    elsif params[:comment_destroy] == "2"
         @comment = params[:comment_id]
         Comment.find_by(id: params[:comment_id], portfolio_id: params[:id]).destroy
  
    elsif params[:reply_destroy] == "3"
        @reply = params[:reply_comment_id]
        ReplyComment.find_by(id: params[:reply_comment_id],comment_id: params[:comment_id]).destroy
        @portfolio = Portfolio.find(params[:portfolio_id])
        @comments = Comment.includes(:user).where(portfolio_id: params[:portfolio_id]).page(params[:page]).per(4)
        @reply_comment = ReplyComment.new
    end
   
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
  
  def comment_params
    params.require(:comment).permit(:comment,:rate).merge(portfolio_id: params[:portfolio_id])
  end
  
  def reply_comment_params
    params.require(:reply_comment).permit(:reply_comment).merge(comment_id: params[:comment_id],user_id: current_user.id)
  end
  
end
