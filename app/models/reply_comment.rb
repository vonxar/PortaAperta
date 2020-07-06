class ReplyComment < ApplicationRecord
    #アソシエーション
  belongs_to :comment
  belongs_to :user
end
