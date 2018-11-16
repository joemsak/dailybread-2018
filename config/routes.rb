require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :current_pay_period, only: :show
    resource :income, only: [:show, :create, :update]

    resources :bills, except: [:new, :edit]
    resources :expenses, except: [:new, :edit]

    resources :users, only: :create
  end

  get :signin, to: 'signins#new', as: :signin
  get :signup, to: 'signups#new', as: :signup

  resources :email_confirmations, only: :show

  root to: "home#show"
end