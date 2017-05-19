Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: 'signout'

  root to: 'pages#index'

  scope module: :pages do
    get '/profile', to: 'profiles#index'
    get '/profile/update', to: 'profiles#update'
  end
end
