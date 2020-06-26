class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
        # :omniauthable, omniauth_providers: %i(github)  github_sns_sign_in
         
  # アソシエーション
  has_many :favorites,dependent: :destroy
  has_many :favorite_portfolios, through: :favorites, source: :portfolio
  has_many :likes,dependent: :destroy
  has_many :portfolios,dependent: :destroy
  has_many :comments, dependent: :destroy
  acts_as_taggable_on :tags
  
  
  
   def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "guest"
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
   end
   
  # def self.create_unique_string
  #   SecureRandom.uuid
  # end
  
  # def self.find_for_github_oauth(auth, signed_in_resource=nil)
  #   user = User.find_by(provider: auth.provider, uid: auth.uid)

  #   unless user
  #     user = User.new(provider: auth.provider,
  #                     uid:      auth.uid,
  #                     name:     auth.info.name,
  #                     email:    User.dummy_email(auth),
  #                     password: Devise.friendly_token[0, 20]
  #     )
  #   end
  #   user.save
  #   user
  # end
  
  # def self.dummy_email(auth)
  #   "#{auth.uid}-#{auth.provider}@example.com"
  # end github_sns_sign_in
  
end
