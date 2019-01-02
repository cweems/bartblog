Rails.application.routes.draw do

  authenticated do
    root :to => 'posts#new', as: :authenticated
  end

  root to: "welcome#index"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :posts

  get '/tos', :to => 'welcome#tos', :as => :tos
  get '/privacy', :to => 'welcome#privacy', :as => :privacy
end
