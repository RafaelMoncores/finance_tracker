Rails.application.routes.draw do
  resources :user_stocks, only: [ :create ]
  devise_for :users
  root to: "home#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search"
  get "up" => "rails/health#show", as: :rails_health_check
end
