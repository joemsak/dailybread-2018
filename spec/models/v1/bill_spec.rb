require 'rails_helper'

RSpec.describe V1::Bill, type: :model do
  it "can set the current pay period" do
    Timecop.freeze(Date.new(2018, 11, 15)) do
      bill = FactoryBot.create(:bill, pay_period: "current")
      expect(bill.pay_period).to eq(2)

      bill.update(pay_period: 1)
      expect(bill.pay_period).to eq(1)
    end
  end
end
