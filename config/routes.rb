Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#show'

  get '/auth/facebook/callback', to: 'users#facebook_create'
end

