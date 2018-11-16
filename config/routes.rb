require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :current_pay_period, only: :show
    resource :income, only: [:show, :create, :update]

    resources :bills, except: [:new, :edit]
    resources :expenses, except: [:new, :edit]

    resources :users, only: :create
    resources :email_confirmations, only: :create

    resources :access_tokens, only: :create
    resources :access_token_refreshes, only: :create
  end

  get :signup, to: 'signups#new', as: :signup
  get :signin, to: 'signins#new', as: :signin
  post :signin, to: 'signins#create', as: :signins
  get :logout, to: 'signins#destroy', as: :logout

  root to: "home#show"
end