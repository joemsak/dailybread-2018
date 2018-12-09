require "rails_helper"

RSpec.describe "Checkouts" do
  describe "POST /checkout" do
    let!(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      allow(Stripe::Customer).to receive(:create) {
        Struct.new(:id).new("cus_123")
      }
    end

    it "adds the token to the current user" do
      expect {
        post v1_checkout_path, params: {
          stripeToken: "tok_123",
          jwt: V1::JWTAuth.for(user)
        }
      }.to change {
        user.reload.payment_gateway_token
      }.from(nil).to("tok_123")
    end

    it "creates the customer" do
      post v1_checkout_path, params: {
        stripeToken: "tok_123",
        jwt: V1::JWTAuth.for(user)
      }

      expect(Stripe::Customer).to have_received(:create).with({
        email: user.email,
        source: "tok_123"
      })
    end

    it "updates the user with the customer id" do
      expect {
        post v1_checkout_path, params: {
          stripeToken: "tok_123",
          jwt: V1::JWTAuth.for(user)
        }
      }.to change {
        user.reload.payment_gateway_customer_id
      }.from(nil).to("cus_123")
    end
  end
end