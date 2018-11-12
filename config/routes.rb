Rails.application.routes.draw do
  namespace :v1 do
    get 'incomes/create'
  end
  api_version module: "V1", path: { value: "v1" }, default: true do
    resource :income, only: [:show, :create, :update]
  end

  root to: "home#show"
end