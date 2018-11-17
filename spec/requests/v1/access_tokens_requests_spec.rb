require "rails_helper"

RSpec.describe "Access Tokens" do
  describe "POST /v1/access_tokens" do
    let(:user) { FactoryBot.create(:user, :confirmed) }

    before do
      user.prepare_for_signin
    end

    it "ignores / 404s for expired tokens (for now)" do
      Timecop.travel(15.minutes.from_now + 1.second)

      post v1_access_tokens_path, params: {
        token: user.magic_signin_token,
      }

      expect(response.status).to eq(404)
    end

    it "expires the magic signin token" do
      Timecop.freeze(Time.current.change(nsec: 0)) do
        this_user = FactoryBot.create(:user, :confirmed)
        this_user.prepare_for_signin

        expect {
          post v1_access_tokens_path, params: {
            token: this_user.magic_signin_token,
          }
        }.to change {
          this_user.reload.magic_signin_token_expires_at
        }.from(15.minutes.from_now).to(Time.zone.local(0))
      end
    end

    it "returns a JWT in JSON" do
      expect(JWT).to receive(:encode).with({
          iss: "leftoverdough.com",
          exp: 10.minutes.from_now.to_i,
          id: user.id,
          email: user.email,
        },
        Rails.application.credentials.secret_key_base,
        'HS256'
      ).and_return("abc123.xyz456.mno789")

      allow(JWT).to receive(:decode).and_return([{ "exp" => 123456789 }])

      post v1_access_tokens_path, params: {
        token: user.magic_signin_token,
      }

      json = JSON.parse(response.body)
      expect(json['jwt']).to eq('abc123.xyz456.mno789')
    end

    it "returns an expiry time in JSON" do
      Timecop.freeze do
        post v1_access_tokens_path, params: {
          token: user.magic_signin_token,
        }

        json = JSON.parse(response.body)
        expect(json['expiresAt']).to eq(10.minutes.from_now.to_i)
      end
    end

    it "returns a refresh token in JSON" do
      expect {
        post v1_access_tokens_path, params: {
          token: user.magic_signin_token,
        }
      }.to change {
        user.reload.access_refresh_token
      }

      json = JSON.parse(response.body)
      expect(json['refreshToken']).to eq(user.access_refresh_token)
    end
  end
end