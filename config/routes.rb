Rails.application.routes.draw do
   devise_for :users, controllers: {
    registrations: 'users/registrations',
     # omniauth_callbacks: "users/omniauth_callbacks" github_sns_sign _in
  }
   devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  root 'homes#top'
  resources :users
  resources :portfolios do
   resources :comments,only: %i[create destroy]
   resource :likes,only: %i[create destroy]
   resource :favorites,only: %i[create destroy]
  end
  resources :categorys
  get '/about' => 'homes#about'
  get '/top' => 'portfolios#top'
  
end
