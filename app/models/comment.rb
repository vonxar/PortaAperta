class Comment < ApplicationRecord
  #アソシエーション
  belongs_to :user
  belongs_to :portfolio
  has_many :reply_comments, dependent: :destroy
  # has_many :replies, class_name: "Comment", foreign_key: :reply_comment, dependent: :destroy
  
   validates :comment, presence: true
   
end
