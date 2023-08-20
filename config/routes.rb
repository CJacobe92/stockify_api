Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :auth, only: [] do
        post 'login', on: :collection, to: 'auth#login', as: 'login'
        # Account activation
        post 'activation', on: :collection, to: 'auth#activation', as: 'activation'
        patch 'activate', on: :collection, to: 'auth#activate', as: 'activate', param: :token, constraints: { token: /[^\/]+/ }
        # Password reset
        post 'password_reset', on: :collection, to: 'auth#password_reset', as: 'password_reset'
        patch 'password_update', on: :collection, to: 'auth#password_update', as: 'password_update', param: :token, constraints: { token: /[^\/]+/ }

        get 'configure_otp/:id', on: :collection, to: 'auth#configure_otp', as: 'configure_otp', param: :id
        patch 'enable_otp/:id', on: :collection, to: 'auth#enable_otp', as: 'enable_otp', param: :id
        post 'verify_otp/:id', on: :collection, to: 'auth#verify_otp', as: 'verify_otp', param: :id
      end

      resources :users do
        resources :accounts do
          resources :transactions
          resources :portfolios
        end
      end

      resources :stocks do
        patch 'update_current_prices', on: :collection, to: 'stocks#update_current_prices', as: 'update_current_prices'
      end
     
      resources :admins
    end
  end
  
end
