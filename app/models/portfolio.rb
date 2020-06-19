class Portfolio < ApplicationRecord
  # アソシエーション
  belongs_to :user
  belongs_to :category
  has_many :likes
  has_many :fovorites
  has_many :comments
end
