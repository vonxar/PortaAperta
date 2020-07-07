class ReplyComment < ApplicationRecord
    #アソシエーション
  belongs_to :comment
  belongs_to :user
  
  validates :reply_comment, presence: true
end
