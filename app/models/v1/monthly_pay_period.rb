class V1::MonthlyPayPeriod
  attr_reader :id, :income

  def initialize(income)
    @income = income
    @id = SecureRandom.hex(12)
  end

  def current_pay_day
    pay_day = if income.specific_monthly.inquiry.last?
                Date.current.end_of_month
              else
                Date.new(
                  Date.current.year,
                  Date.current.month,
                  Integer(income.specific_monthly)
                )
              end

    while !pay_day.on_weekday? || Holidays.on(pay_day, :us, :observed).any?
      pay_day -= 1.day
    end

    pay_day
  end
end