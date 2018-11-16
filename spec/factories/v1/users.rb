FactoryBot.define do
  factory :user, class: V1::User do
    sequence(:email) { |n| "factory-#{n}@example.com" }

    trait :confirmed do
      status { :confirmed }
    end
  end
end
