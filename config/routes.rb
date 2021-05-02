Rails.application.routes.draw do
  resources :rewards
  resources :users
  post "/api/v1/user_events", to:"user_events#received"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
