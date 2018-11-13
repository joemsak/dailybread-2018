class V1::PayPeriodSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  attributes :current
end