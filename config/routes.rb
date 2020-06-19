Rails.application.routes.draw do
   devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'homes#top'
   devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
