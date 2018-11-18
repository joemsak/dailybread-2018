class V1::Income < ApplicationRecord
  enum payroll_type: %i{
    monthly
    semi_monthly_type1
    semi_monthly_type2
    bi_weekly
    weekly
  }

  belongs_to :user
end
