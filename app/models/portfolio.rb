class Portfolio < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :category, optional: true
  has_many :likes
  has_many :fovorites
  has_many :comments
  has_rich_text :body
  #has_one_attached :body
   
  attachment :image
end
