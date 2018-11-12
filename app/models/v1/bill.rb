class V1::Bill < ApplicationRecord
  scope :in_pay_period, ->(num) {
    where(pay_period: num)
  }
end
