Rails.application.routes.draw do
  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :current_pay_period, only: [:show]
    resource :income, only: [:show, :create, :update]

    resources :bills, except: [:new, :edit]
    resources :expenses, except: [:new, :edit]
  end

  root to: "home#show"
end