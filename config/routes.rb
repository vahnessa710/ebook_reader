Rails.application.routes.draw do
  devise_for :users
  
  resources :books, only: [:index, :show] do
    resource :reading_progress, only: [:show, :create, :update]
    resources :vocabularies, only: [:index, :create]
  end
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "books#show"
end
