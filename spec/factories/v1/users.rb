FactoryBot.define do
  factory :user, class: V1::User do
    sequence(:email) { |n| "factory-#{n}@example.com" }

    transient do
      without_income { false }
    end

    trait :confirmed do
      status { :confirmed }
    end

    trait :without_income do
      without_income { true }
    end

    before(:create) do |user, evaluator|
      unless user.income || evaluator.without_income
        user.build_income(FactoryBot.attributes_for(:income))
      end
    end
  end
end
