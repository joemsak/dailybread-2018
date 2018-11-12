Rails.application.routes.draw do
  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :income, only: [:show, :create, :update]
    resources :bills, only: [:index, :show, :create, :update, :destroy]
  end

  root to: "home#show"
end