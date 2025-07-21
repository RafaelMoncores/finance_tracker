Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "up" => "rails/health#show", as: :rails_health_check
end
