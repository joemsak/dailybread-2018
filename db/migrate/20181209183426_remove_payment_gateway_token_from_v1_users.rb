class RemovePaymentGatewayTokenFromV1Users < ActiveRecord::Migration[5.2]
  def change
    remove_column :v1_users, :payment_gateway_token, :string
  end
end
