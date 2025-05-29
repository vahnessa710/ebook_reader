Rails.application.routes.draw do
  
  devise_for :users

  resources :books, only: [:index, :show, :create] do
    get 'download', on: :member
    resources :reading_progress, only: [:show, :create, :update]
    resources :chapters, only: [:show]
    
    
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
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "books#index"
end
