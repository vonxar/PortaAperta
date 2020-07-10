Rails.application.routes.draw do
  root 'homes#top'
  devise_for :users, controllers: {
   registrations: 'users/registrations',
     # omniauth_callbacks: "users/omniauth_callbacks" github_sns_sign _in
  }
   devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
   end
  resources :users
  resources :notifications, only: :index do
   collection do
    delete 'destroy_all'
   end
  end
  post '/portfolios/:id',to: 'portfolios#show'
  resources :portfolios do
   resources :comments,only: %i[create destroy] do
    resources :reply_comments,only: %i[create destroy]
   end
   resource :likes,only: %i[create destroy]
   resource :favorites,only: %i[create destroy]
   resources :assessments,only: %i[create destroy]
   collection do
      get 'search'
   end
  end
  resources :categorys
  get '/about' => 'homes#about'
  get '/top' => 'portfolios#top'
  
end
