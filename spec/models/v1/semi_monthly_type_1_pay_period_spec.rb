require "rails_helper"

RSpec.describe V1::SemiMonthlyType1PayPeriod do
  describe ".current(income)" do
    context "twice per month, 1st and 15th" do
      let!(:income) { FactoryBot.create(:income, :semi_monthly_type1) }

      it "returns 1 before the 15th" do
        Timecop.freeze(2019, 1, 3) do
          period = V1::PayPeriod.for(income)

          expect(period.current_pay_day_1).to eq(Date.new(2018, 12, 31))
          expect(period.current_pay_day_2).to eq(Date.new(2019, 1, 15))
          expect(period.current).to eq(1)
        end
      end

      it "returns 2 on and after the 15th" do
        Timecop.freeze(2018, 11, 15) do
          expect(V1::PayPeriod.for(income).current).to eq(2)
        end

        Timecop.freeze(2018, 11, 19) do
          expect(V1::PayPeriod.for(income).current).to eq(2)
        end
      end

      it "detects pay days on weekends" do
        Timecop.freeze(2018, 12, 14) do
          expect(V1::PayPeriod.for(income).current).to eq(2)
        end
      end

      it "detects pay days on holidays" do
        Timecop.freeze(2018, 1, 12) do
          expect(V1::PayPeriod.for(income).current).to eq(2)
        end
      end
    end
  end
end