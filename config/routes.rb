Rails.application.routes.draw do
  # Authentication routes
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # Resume routes
  get 'resume/edit', to: 'resume#edit', as: 'edit_resume'
  patch 'resume', to: 'resume#update'
  
  # Blog posts - full CRUD operations
  resources :posts
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Define the root path route ("/")
  root 'resume#index'
end
