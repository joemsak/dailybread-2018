require "rails_helper"

RSpec.describe "Income" do
  let!(:user) { FactoryBot.create(:user, :confirmed, :without_income) }
  let(:jwt) { V1::JWTAuth.for(user) }

  describe "POST /v1/income" do
    it "saves the income per pay period" do
      expect {
        post v1_income_path(format: :json), params: {
          income: {
            amount: 2000,
            payroll_type: :semi_monthly_type2,
          }
        }, headers: {
          'x-access-token' => jwt,
        }
      }.to change {
        user.reload.income
      }.from(nil)

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['id']).to eq(String(user.income.id))
    end
  end

  describe "GET /income" do
    it "retrieves the user's income per pay period" do
      user_income = FactoryBot.create(:income, user: user)
      FactoryBot.create(:income)

      get v1_income_path(format: :json), headers: {
        'x-access-token' => jwt
      }

      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq(String(user_income.id))
      expect(json['attributes']['amount']).to eq(user_income.amount)
    end
  end

  describe "PATCH /income" do
    it "updates the user's income per pay period" do
      user_income = FactoryBot.create(:income, user: user, amount: 3000)
      FactoryBot.create(:income, amount: 2000)

      expect {
        patch v1_income_path(format: :json), params: {
          income: {
            amount: 1_000_000,
            payroll_type: :semi_monthly_type1,
          }
        }, headers: {
          'x-access-token' => jwt
        }

      }.to change {
        user_income.reload.amount
      }.from(3000).to(1_000_000)
      .and change {
        user_income.reload.payroll_type
      }.from("semi_monthly_type2").to("semi_monthly_type1")

      expect(response.status).to eq(204)
    end
  end
end
