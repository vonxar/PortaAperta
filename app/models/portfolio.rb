class Portfolio < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :category, optional: true
  has_many :likes,dependent: :destroy
  has_many :favorites
  has_many :comments,dependent: :destroy
  
  acts_as_taggable
  acts_as_taggable_on :tag, :interests
	
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
end
