FactoryBot.define do
  factory :income, class: V1::Income do
    amount { 1 }
    payroll_type { "semi_monthly_type2" }
    user

    trait :semi_monthly_type2 do
      payroll_type { "semi_monthly_type2" }
    end

    trait :semi_monthly_type1 do
      payroll_type { "semi_monthly_type1" }
    end

    trait :monthly do
      payroll_type { "monthly" }
    end

    trait :weekly do
      payroll_type { "weekly" }
    end

    trait :bi_weekly do
      payroll_type { "bi_weekly" }
    end
  end
end
