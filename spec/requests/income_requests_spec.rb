require "rails_helper"

RSpec.describe "Income" do
  describe "POST /income" do
    it "saves the income per pay period" do
      expect {
        post v1_income_path, params: {
          income: {
            amount: 2000
          },
        }
      }.to change {
        Income.count
      }.from(0).to(1)
    end
  end
end
