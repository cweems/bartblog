Rails.application.routes.draw do
  root to: "posts#new"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :posts
end
