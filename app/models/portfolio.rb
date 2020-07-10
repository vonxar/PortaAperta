class Portfolio < ApplicationRecord
  is_impressionable
  # アソシエーション
  belongs_to :user
  belongs_to :category, optional: true
  has_many :likes,dependent: :destroy
  has_many :favorites
  has_many :comments,dependent: :destroy
  has_many :notifications, dependent: :destroy
  
  acts_as_taggable
  acts_as_ordered_taggable_on :tags
  
  def stringify(tag_list)
    tag_list.inject('') { |memo, tag| memo += (tag + ',') }[0..-1]
  end
  
  #validates
  validates :title, presence: true
  validates :body, presence: true
  #end
  
	
  # いいね判定
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
   
   # お気に入り判定 → vies側で呼び出し
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  
  has_rich_text :body
  #has_one_attached :body
   
  attachment :image
  #ソート 
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes' #Like.group(:portfolio_id)で、post_idが同じ投稿をグループ分けします。 
    #order(Arel.sql('count(portfolio_id) desc'))で、グループ分けされた投稿へどれだけuser_idが格納されているかをカウントして多いものから並べます（いいねされているかを集計してます）。
      return find(Like.group(:portfolio_id).order(Arel.sql('count(portfolio_id) desc')).pluck(:portfolio_id))
      #pluck(:portfolio_id)では、portfolio_idそのものの取得を行っています。これを記述しないと、portfolioへ対して呼び出しているfindに該当するものが見つからず、エラーになってしまいます。
    when 'dislikes'
      return find(Like.group(:portfolio_id).order(Arel.sql('count(portfolio_id) asc')).pluck(:portfolio_id))
    when 'visit'
       return find(Impression.group(:impressionable_id).order('count(impressionable_id) desc').limit(3).pluck(:impressionable_id))
    when 'ranking_likes'
      return find(Like.group(:portfolio_id).order(Arel.sql('count(portfolio_id) desc')).limit(3).pluck(:portfolio_id))
    when 'ranking_comment'
      return find(Comment.group(:portfolio_id).order(Arel.sql('count(portfolio_id) desc')).limit(3).pluck(:portfolio_id))
    end
  end
  
  def word
    case word
    when 'visit'
      return "PV"
    when 'ranking_likes'
      return "いいね"
    when 'ranking_comment'
      return "コメント"
    end
  end
  
  # 通知関係
   def create_notification_by(current_user)
        notification = current_user.active_notifications.new(
          portfolio_id: id,
          visited_id: user_id,
          action: "like"
        )
        notification.save if notification.valid?
   end

  def create_notification_comment!(current_user, comment_id)
      # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
      temp_ids = Comment.select(:user_id).where(portfolio_id: id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
       save_notification_comment!(current_user, comment_id, temp_id['user_id'])
      end
      # まだ誰もコメントしていない場合は、投稿者に通知を送る
      save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      portfolio_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
      notification.save if notification.valid?
  end
  
  
  
  
  
    # ---------------------------------------
  def create_notification_reply_comment!(current_user, comment_id,reply_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = ReplyComment.select(:user_id).where(comment_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
     save_notification_reply_comment!(current_user, comment_id, temp_id['user_id'], reply_id)
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_reply_comment!(current_user, comment_id, user_id, reply_id) if temp_ids.blank?
  end

  def save_notification_reply_comment!(current_user, comment_id, visited_id, reply_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      portfolio_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      reply_id: reply_id,
      action: 'reply_comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
      notification.save if notification.valid?
  end
end