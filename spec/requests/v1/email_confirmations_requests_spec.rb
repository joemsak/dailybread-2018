require "rails_helper"

RSpec.describe "Email Confirmations" do
  describe "POST /v1/email_confirmations" do
    let!(:user) { FactoryBot.create(:user) }

    it "confirms pending users" do
      expect {
        post v1_email_confirmations_path, params: {
          token: user.email_confirmation_token
        }
      }.to change {
        user.reload.status
      }.from("pending").to("confirmed")
    end

    it "302s for expired tokens" do
      Timecop.travel(4.hours.from_now + 1.second)

      expect {
        post v1_email_confirmations_path, params: {
          token: user.email_confirmation_token,
        }
      }.not_to change {
        user.reload.status
      }.from("pending")

      expect(response.status).to eq(302)
    end

    it "expires the confirmation token" do
      Timecop.freeze(Time.current.change(nsec: 0)) do
        this_user = FactoryBot.create(:user)

        expect {
          post v1_email_confirmations_path, params: {
            token: this_user.email_confirmation_token,
          }
        }.to change {
          this_user.reload.email_confirmation_token_expires_at
        }.from(4.hours.from_now).to(Time.zone.local(0))
      end
    end

    it "returns a JWT in JSON" do
      user = FactoryBot.create(:user)
      fake_token = "abc123.xyz456.mno789"

      expect(JWT).to receive(:encode).with({
          iss: "leftoverdough.com",
          exp: 10.minutes.from_now.to_i,
          id: user.id,
          email: user.email,
        },
        Rails.application.credentials.secret_key_base,
        'HS256'
      ).and_return(fake_token)

      expect(V1::JWTAuth).to receive(:decode).with(fake_token) {
        [{
          'exp' => 1234567890,
        }]
      }

      post v1_email_confirmations_path, params: {
        token: user.email_confirmation_token,
      }

      expect(response.headers['x-access-token']).to eq(fake_token)
      expect(response.headers['x-access-token-expires-at']).to eq(1234567890)
      expect(response.headers['x-access-refresh-token']).to eq(user.access_refresh_token)
    end
  end
end