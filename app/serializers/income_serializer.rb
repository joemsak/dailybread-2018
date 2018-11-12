class IncomeSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  attributes :amount
end
