class V1::SemiMonthlyType2PayPeriod
  attr_reader :id, :income

  def initialize(income)
    @income = income
    @id = SecureRandom.hex(12)
  end

  def previous_pay_day_2
    previous_pay_day_2 = (Date.current - 1.month).end_of_month

    while !previous_pay_day_2.on_weekday? ||
            Holidays.on(previous_pay_day_2, :us, :observed).any?
      previous_pay_day_2 -= 1.day
    end

    previous_pay_day_2
  end

  def current_pay_day_1
    pay_day_1 = Date.new(Date.current.year, Date.current.month, 15)

    while !pay_day_1.on_weekday? || Holidays.on(pay_day_1, :us, :observed).any?
      pay_day_1 -= 1.day
    end

    pay_day_1
  end

  def current_pay_day_2
    pay_day_2 = Date.current.end_of_month

    while !pay_day_2.on_weekday? || Holidays.on(pay_day_2, :us, :observed).any?
      pay_day_2 -= 1.day
    end

    pay_day_2
  end

  def current
    if Date.current < current_pay_day_1 || Date.current >= current_pay_day_2
      1
    else
      2
    end
  end
end