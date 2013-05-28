Softandfluffynotes::Application.routes.draw do
  get "notes/index"

  get "users", to: "users#index"

  devise_for :users

  root to: "users#index"
end
