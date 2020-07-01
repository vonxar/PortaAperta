class Portfolio < ApplicationRecord
  is_impressionable
  # アソシエーション
  belongs_to :user
  belongs_to :category, optional: true
  has_many :likes,dependent: :destroy
  has_many :favorites
  has_many :comments,dependent: :destroy
  
  acts_as_taggable
  
	
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
    end
  end
end