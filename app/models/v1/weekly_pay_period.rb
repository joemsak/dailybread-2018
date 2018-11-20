class V1::WeeklyPayPeriod
  attr_reader :id, :income

  def initialize(income)
    @income = income
    @id = SecureRandom.hex(12)
  end

  def current_pay_day
    pay_day = Date.current.end_of_week

    while pay_day.strftime("%A").downcase != income.specific_weekly
      pay_day -= 1
    end

    if Date.current >= pay_day
      pay_day += 1.week
    end

    while !pay_day.on_weekday? || Holidays.on(pay_day, :us, :observed).any?
      pay_day -=1
    end

    pay_day
  end
end