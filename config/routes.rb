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
  get '/passwords/edit', to: 'passwords#edit', as: 'edit_password'
  put '/passwords', to: 'passwords#update', as: 'password'
  post '/passwords/reset', to: 'passwords#reset', as: 'password_reset'

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
  get '/privacy', to: 'pages#privacy', as: 'privacy'
  get '/terms', to: 'pages#terms', as: 'terms'
  get '/contact', to: 'pages#contact', as: 'contact'
  post '/contact', to: 'pages#send_message'

  #admin
  get '/admin/login', to: 'users#admin_login', as: 'admin_login'
  post '/admin', to: 'users#admin_authenticate'

  require 'sidekiq/web'
  constraints Clearance::Constraints::SignedIn.new { |user| user.is_admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end




end

