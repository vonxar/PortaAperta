class Like < ApplicationRecord
  #アソシエーション
  belongs_to :user
  belongs_to :portfolio
  
  validates_uniqueness_of :portfolio_id, scope: :user_id
end
