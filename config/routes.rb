Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]



  post '/users', to: 'users#create'
  post '/session', to: 'sessions#create'
  get '/sign_in', to: 'sessions#new', as: 'login'
  get '/sign_up', to: 'users#new', as: 'register'

  root to: "sessions#new"
  resources :users


  get '/auth/facebook/callback', to: 'users#facebook_create'
  get '/signout', to: 'sessions#destroy'



end

