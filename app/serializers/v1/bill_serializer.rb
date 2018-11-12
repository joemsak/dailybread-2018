class V1::BillSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :amount, :pay_period
end
