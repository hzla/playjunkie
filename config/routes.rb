Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  resources :passwords, controller: "clearance/passwords", only: [:create]

  root to: "quizzes#index"

  #sessions
  post '/session', to: 'sessions#create'
  get '/sign_in', to: 'sessions#new', as: 'login'
  get '/sign_up', to: 'users#new', as: 'register'
  get '/auth/facebook/callback', to: 'users#facebook_create'
  get '/signout', to: 'sessions#destroy'

  #users
  resources :users

  #passwords 
  get '/passwords/new', to: 'passwords#new', as: 'new_password'

  #quizzes
  get '/trending', to: 'quizzes#trending', as: 'trending'
  get '/browse/:quiz_type', to: 'quizzes#browse', as: 'browse'
  get '/quizzes/featured', to: 'quizzes#featured', as: 'featured'
  get '/quizzes/new/:quiz_type', to: 'quizzes#new', as: 'new_quiz'
  resources :quizzes

  #searches
  post '/searches', to: 'searches#create'
  get '/searches', to: 'searches#show', as: 'search'

  #pages
  get '/about', to: 'pages#about', as: 'about'
  get '/privacy', to: 'pages#privacy', as: 'privacy'
  get '/terms', to: 'pages#terms', as: 'terms'




end

