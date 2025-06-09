Rails.application.routes.draw do
  devise_for :users

  resources :books, only: [:index, :show, :create, :destroy] do
    get 'download', on: :member
    resources :reading_progress, only: [:show, :create, :update]
    resources :chapters, only: [:show] do
      member do
        post :update_progress
      end
    end
    collection do
      get :search_form    # GET /books/search_form (search form page)
      get :search        # POST /books/search (submits ID to fetch/save book)
    end
  end

  resources :vocabularies do

   collection do
      get :search_form    # GET /vocabularies/search_form (search form page)
      get :search        # POST /vocabularies/search (submits ID to fetch/save book)
      post :search
    end
  end
  
   resources :users do
    resources :notes
  end

  resources :users do
    member do
      patch :update_theme
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
      root to: "books#index", as: :authenticated_root
    end

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
