FactoryBot.define do
  factory :bill, class: V1::Bill do
    amount { 1 }
    name { "MyString" }
    pay_period { 1 }
  end
end
