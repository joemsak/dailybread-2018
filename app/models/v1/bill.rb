class V1::Bill < ApplicationRecord
  scope :in_pay_period, ->(num, income) {
    if String(num) == "current"
      num = V1::PayPeriod.for(income).current
    end

    where(pay_period: num)
  }

  before_save -> {
    if pay_period.to_i.zero?
      self.pay_period = V1::PayPeriod.for(user.income).current
    end
  }

  belongs_to :user
end
