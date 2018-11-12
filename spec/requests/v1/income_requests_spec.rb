require "rails_helper"

RSpec.describe "Income" do
  describe "POST /v1/income" do
    it "saves the income per pay period" do
      expect {
        post v1_income_path, params: {
          income: {
            amount: 2000
          },
        }
      }.to change {
        V1::Income.count
      }.from(0).to(1)

      expect(response.status).to eq(201)
      expect(JSON.parse(response.body)['data']['id']).not_to be_nil
    end
  end

  describe "GET /income" do
    it "retrieves the income per pay period" do
      income = FactoryBot.create(:income)

      get v1_income_path

      json = JSON.parse(response.body)['data']

      expect(json['id']).to eq(String(income.id))
      expect(json['attributes']['amount']).to eq(income.amount)
    end
  end

  describe "PATCH /income" do
    it "updates the income per pay period" do
      income = FactoryBot.create(:income, amount: 2000)

      expect {
        patch v1_income_path, params: {
          income: {
            amount: 1_000_000
          }
        }
      }.to change {
        income.reload.amount
      }.from(2000).to(1_000_000)

      expect(response.status).to eq(204)
    end
  end
end
