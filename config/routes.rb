Softandfluffynotes::Application.routes.draw do
  get "notes", to: "notes#index", as: "notes_index"

  get "users", to: "users#index"

  devise_for :users, controllers: {registrations: "registrations"}

  root to: "notes#index"
end
