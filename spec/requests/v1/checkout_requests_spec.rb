require "rails_helper"

RSpec.describe "Checkouts" do
  describe "POST /checkout" do
    let!(:user) { FactoryBot.create(:user, :confirmed) }
    let(:jwt) { V1::JWTAuth.for(user) }

    before do
      allow(Stripe::Customer).to receive(:create) {
        Struct.new(:id).new("cus_123")
      }

      allow(Stripe::Subscription).to receive(:create) {
        Struct.new(:id).new("sub_123")
      }
    end

    it "creates the customer" do
      post v1_checkout_path(format: :json), params: {
        stripe_token: "tok_123",
      }, headers: {
        'x-access-token' => jwt
      }

      expect(Stripe::Customer).to have_received(:create).with({
        email: user.email,
        source: "tok_123"
      })
    end

    it "updates the user with the customer id" do
      expect {
        post v1_checkout_path(format: :json), params: {
          stripe_token: "tok_123",
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.reload.payment_gateway_customer_id
      }.from(nil).to("cus_123")
    end

    it "creates the subscription" do
      expect {
        post v1_checkout_path(format: :json), params: {
          stripe_token: "tok_123",
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.reload.payment_gateway_subscription_id
      }.from(nil).to("sub_123")

      expect(Stripe::Subscription).to have_received(:create).with({
        customer: 'cus_123',
        items: [{plan: Rails.application.credentials.stripe[:plan_id]}],
      })
    end
  end
end