Rails.application.routes.draw do
  # Root endpoint
  root 'home#index'

  # Health check endpoint
  get '/health', to: 'home#health'

  # Environment variables endpoint (public only)
  get '/env', to: 'home#env'

  # API routes
  namespace :api do
    resources :tasks
  end
end
