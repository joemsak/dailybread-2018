class V1::PayPeriod
  def self.for(income)
    "V1::#{income.payroll_type.camelize}PayPeriod".constantize.new(income)
  end
end