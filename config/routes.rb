Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'signout'

  root to: 'pages#index'
end
