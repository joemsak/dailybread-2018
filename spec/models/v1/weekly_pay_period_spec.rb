require "rails_helper"

RSpec.describe V1::WeeklyPayPeriod do
  describe "#current_pay_day" do
    context "weekly" do
      it "returns the upcoming specific weekly pay day for the week" do
        income = FactoryBot.create(
          :income,
          :weekly,
          specific_weekly: "thursday"
        )

        Timecop.freeze(2018, 11, 1) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 8)
          )
        end

        Timecop.freeze(2018, 10, 31) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 1)
          )
        end
      end

      it "detects pay days on holidays" do
        income = FactoryBot.create(
          :income,
          :weekly,
          specific_weekly: "monday",
        )

        Timecop.freeze(2018, 1, 11) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 1, 12)
          )
        end
      end
    end
  end
end