class V1::IncomeSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  attributes :amount
end
