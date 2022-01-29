Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'api/v1/teams#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :countries, only: [:index]

      resources :players, only: [:update] do
        member do
          patch :transfer
          patch :buy
        end
      end

      resources :sessions, only: [:create]

      resources :teams, only: [:index, :update]

      resources :transfers, only: [:index]

      resources :users, only: [:create]
    end
  end
end
