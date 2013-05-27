Softandfluffynotes::Application.routes.draw do
  get "users", to: "users#index"

  devise_for :users

  root to: "users#index"
end
