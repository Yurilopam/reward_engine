Rails.application.routes.draw do
  resources :rewards
  resources :users
  post "/api/v1/user_events", to:"user_events#received"
  get "/api/v1/rewards", to:"rewards_api#get_possible_rewards"
  post "/api/v1/users/:user_id/redeems", to:"users_api#redeems"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
