require "rails_helper"

RSpec.describe "Checkouts" do
  describe "POST /checkout" do
    it "adds the token to the current user" do
      user = FactoryBot.create(:user, :confirmed)

      expect {
        post v1_checkout_path, params: {
          stripe_token: "abc123"
        }, headers: {
          'x-access-token' => V1::JWTAuth.for(user)
        }
      }.to change {
        user.reload.payment_gateway_token
      }.from(nil).to("abc123")
    end
  end
end