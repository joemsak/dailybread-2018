FactoryBot.define do
  factory :income, class: V1::Income do
    amount { 1 }
    user
  end
end
