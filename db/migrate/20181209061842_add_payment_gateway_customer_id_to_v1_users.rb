class AddPaymentGatewayCustomerIdToV1Users < ActiveRecord::Migration[5.2]
  def change
    add_column :v1_users, :payment_gateway_customer_id, :string
  end
end
