Rails.application.routes.draw do
  devise_for :users

  resources :books, only: [:index, :show, :create, :destroy] do
    get 'download', on: :member
    resources :reading_progress, only: [:show, :create, :update]
    resources :chapters, only: [:show]
    
    collection do
      get :search_form    # GET /books/search_form (search form page)
      get :search        # POST /books/search (submits ID to fetch/save book)
    end
  end

  resources :vocabularies, only: [:index, :create]

  get "up" => "rails/health#show", as: :rails_health_check

  root "books#index"
end
