require "rails_helper"

RSpec.describe "Access Token Refreshes" do
  describe "POST /v1/access_token_refreshes" do
    let(:user) { FactoryBot.create(:user, :confirmed) }
    let!(:jwt) { V1::JWTAuth.for(user) }

    it "ignores / 404s for incorrect tokens" do
      post v1_access_token_refreshes_path, params: {
        token: "foo"
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)
    end

    it "ignores / 401 for expired JWTs" do
      Timecop.travel(10.minutes + 1.second)

      post v1_access_token_refreshes_path, params: {
        token: user.access_refresh_token,
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(401)
    end

    it "regenerates the original refresh token" do
      expect {
        post v1_access_token_refreshes_path, params: {
          token: user.access_refresh_token,
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.reload.access_refresh_token
      }
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
      ).and_call_original

      post v1_access_token_refreshes_path, params: {
        token: user.access_refresh_token,
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.headers['x-access-token']).not_to be_nil
    end

    it "returns an expiry time in JSON" do
      Timecop.freeze do
        post v1_access_token_refreshes_path, params: {
          token: user.access_refresh_token,
        }, headers: {
          'x-access-token' => jwt
        }

        expect(response.headers['x-access-token-expires-at']).to eq(10.minutes.from_now.to_i)
      end
    end

    it "returns the new refresh token in JSON" do
      post v1_access_token_refreshes_path, params: {
        token: user.access_refresh_token,
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.headers['x-access-refresh-token']).to eq(user.reload.access_refresh_token)
    end
  end
end