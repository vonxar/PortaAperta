class Portfolio < ApplicationRecord
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
  is_impressionable
  #ソート
  def self.sort(selection)
    case selection
    when 'new'
      return all.order(created_at: :DESC)
    when 'old'
      return all.order(created_at: :ASC)
    when 'likes'
      return find(Like.group(:portfolio_id).order(Arel.sql('count(portfolio_id) desc')).pluck(:portfolio_id))
    when 'dislikes'
      return find(Like.group(:portfolio_id).order(Arel.sql('count(portfolio_id) asc')).pluck(:portfolio_id))
    end
  end
  
end
