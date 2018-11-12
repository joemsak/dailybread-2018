class V1::Bill < ApplicationRecord
  scope :in_pay_period, ->(num) {
    if String(num) == "current"
      num = V1::PayPeriod.current
    end

    where(pay_period: num)
  }
end
