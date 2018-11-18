class V1::Expense < ApplicationRecord
  scope :in_current_pay_period, ->(income) {
    period = V1::PayPeriod.for(income)

    if (period.current === 1)
      where(
        "made_on >= ? AND made_on < ?",
        period.previous_pay_day_2,
        period.current_pay_day_1
      )
    else
      where(
        "made_on >= ? AND made_on < ?",
        period.current_pay_day_1,
        period.current_pay_day_2
      )
    end
  }

  belongs_to :user
end
