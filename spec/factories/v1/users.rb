FactoryBot.define do
  factory :user, class: V1::User do
    sequence(:email) { |n| "factory-#{n}@example.com" }
  end
end
