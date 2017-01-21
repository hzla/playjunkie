Rails.application.routes.draw do
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]



  post '/users', to: 'users#create'
  post '/session', to: 'sessions#create'
  get '/sign_in', to: 'sessions#new', as: 'login'
  get '/sign_up', to: 'users#new', as: 'register'

  root to: "quizzes#index"
  resources :users

  get '/quizzes/new_trivia', to: 'quizzes#new_trivia', as: 'new_trivia'
  get '/quizzes/new_quiz', to: 'quizzes#new_quiz', as: 'new_new_quiz'
  get '/quizzes/new_flipcard', to: 'quizzes#new_flipcard', as: 'new_flipcard'
  get '/quizzes/new_list', to: 'quizzes#new_list', as: 'new_list'
  resources :quizzes



  get '/auth/facebook/callback', to: 'users#facebook_create'
  get '/signout', to: 'sessions#destroy'



end

