class AddPaymentGatewaySubscriptionIdToV1Users < ActiveRecord::Migration[5.2]
  def change
    add_column :v1_users, :payment_gateway_subscription_id, :string
  end
end
