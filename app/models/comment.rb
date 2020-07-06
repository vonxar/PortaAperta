class Comment < ApplicationRecord
  #アソシエーション
  belongs_to :user
  belongs_to :portfolio
  has_many :reply_comments, dependent: :destroy
end
