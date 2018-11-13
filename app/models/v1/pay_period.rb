class V1::PayPeriod
  def self.current
    today = Date.current

    pay_day_1 = Date.new(today.year, today.month, 15)
    pay_day_2 = today.end_of_month

    while !pay_day_1.on_weekday? || Holidays.on(pay_day_1, :us, :observed).any?
      pay_day_1 -= 1.day
    end

    while !pay_day_2.on_weekday? || Holidays.on(pay_day_2, :us, :observed).any?
      pay_day_2 -= 1.day
    end

    if today < pay_day_1 || today >= pay_day_2
      1
    else
      2
    end
  end

  def id
    SecureRandom.hex(12)
  end

  def current
    self.class.current
  end
end