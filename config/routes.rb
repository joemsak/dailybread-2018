Rails.application.routes.draw do
  namespace :v1 do
    get 'users/create'
  end
  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :current_pay_period, only: :show
    resource :income, only: [:show, :create, :update]

    resources :bills, except: [:new, :edit]
    resources :expenses, except: [:new, :edit]

    resources :users, only: :create
  end

  root to: "home#show"
end