Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :auth, only: [] do
        post 'login', on: :collection, to: 'auth#login', as: 'login'
        post 'password_reset', on: :collection, to: 'auth#password_reset', as: 'password_reset'
        post 'activation', on: :collection, to: 'auth#activation', as: 'activation'
        patch 'activate', on: :collection, to: 'auth#activate', as: 'activate'
      end
      resources :users
    end
  end
  
end
