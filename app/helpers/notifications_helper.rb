module NotificationsHelper
  
    def notification_form(notification)
      @visiter = notification.visiter
      @comment = nil
      your_item = link_to 'あなたの投稿', portfolios_path(notification), style:"font-weight: bold;"
      @visiter_comment = notification.comment_id
      #notification.actionがfollowかlikeかcommentか
      case notification.action
        when "like" then
          tag.a(notification.visiter.name, href:users_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:portfolio_path(notification.portfolio_id), style:"font-weight: bold;")+"にいいねしました"
        when "reply_comment"
            @reply = ReplyComment.find_by(id: @visiter_comment)
            tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたのコメント', href:portfolio_path(notification.portfolio_id), style:"font-weight: bold;")+"に返信しました"
        when "comment" then
            @comment = Comment.find_by(id: @visiter_comment)
            tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が"+tag.a('あなたの投稿', href:portfolio_path(notification.portfolio_id), style:"font-weight: bold;")+"にコメントしました"
      end
    end
    
    def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
    end
    
end
