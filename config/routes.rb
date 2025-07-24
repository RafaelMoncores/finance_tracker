Rails.application.routes.draw do
  resources :user_stocks, only: [ :create, :destroy ]
  resources :friendships, only: [ :create, :destroy ]
  devise_for :users
  root to: "home#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get "my_friends", to: "users#my_friends"
  get "search_friend", to: "users#search_friend"
  get "up" => "rails/health#show", as: :rails_health_check
end
