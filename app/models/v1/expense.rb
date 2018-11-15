class V1::Expense < ApplicationRecord
  scope :in_current_pay_period, -> {
    if (V1::PayPeriod.current === 1)
      where("made_on >= ? AND made_on < ?",
        V1::PayPeriod.previous_pay_day_2,
        V1::PayPeriod.current_pay_day_1)
    else
      where("made_on >= ? AND made_on < ?",
        V1::PayPeriod.current_pay_day_1,
        V1::PayPeriod.current_pay_day_2)
    end
  }
end
