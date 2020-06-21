class Category < ApplicationRecord
   #アソシエーション
   has_many :portfolios
end
