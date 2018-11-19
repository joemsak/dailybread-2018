class V1::IncomeSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  attributes :amount, :payroll_type, :specific_monthly, :specific_weekly
end
