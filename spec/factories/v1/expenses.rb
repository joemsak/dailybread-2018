FactoryBot.define do
  factory :expense, class: V1::Expense do
    category { "Factory Category" }
    name { "factory name" }
    amount { 9.99 }
    made_on { Date.today }
    user
  end
end
