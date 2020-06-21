class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # アソシエーション
  has_many :favorites
  has_many :likes
  has_many :portfolios,dependent: :destroy
  has_many :comments
  
   def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "guest"
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
   end
end
