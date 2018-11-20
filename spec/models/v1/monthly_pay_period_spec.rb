require "rails_helper"

RSpec.describe V1::MonthlyPayPeriod do
  describe "#current_pay_day" do
    context "monthly" do
      it "returns the specific monthly pay day" do
        income = FactoryBot.create(
          :income,
          :monthly,
          specific_monthly: 13
        )

        Timecop.freeze(2018, 11, 1) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 13)
          )
        end
      end

      it "detects the last day pay day" do
        income = FactoryBot.create(
          :income,
          :monthly,
          specific_monthly: :last
        )

        Timecop.freeze(2018, 11, 12) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 30)
          )
        end

        Timecop.freeze(2016, 2, 12) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2016, 2, 29)
          )
        end
      end

      it "detects pay days on weekends" do
        income = FactoryBot.create(
          :income,
          :monthly,
          specific_monthly: 15,
        )

        Timecop.freeze(2018, 12, 1) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 12, 14)
          )
        end
      end

      it "detects pay days on holidays" do
        income = FactoryBot.create(
          :income,
          :monthly,
          specific_monthly: 15,
        )

        Timecop.freeze(2018, 1, 1) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 1, 12)
          )
        end
      end
    end
  end
end