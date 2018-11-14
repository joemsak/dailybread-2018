FactoryBot.define do
  factory :expense, class: V1::Expense do
    category { "MyString" }
    name { "MyString" }
    amount { 9.99 }
    made_on { "2018-11-14" }
  end
end
