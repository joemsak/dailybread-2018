require "rails_helper"

RSpec.describe V1::BiWeeklyPayPeriod do
  describe "#current_pay_day" do
    context "bi_weekly" do
      it "returns the upcoming specific bi-weekly pay day for the week" do
        income = FactoryBot.create(
          :income,
          :bi_weekly,
          specific_weekly: "tuesday"
        )

        Timecop.freeze(2018, 11, 1) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 6)
          )
        end

        Timecop.freeze(2018, 11, 6) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 20)
          )
        end

        Timecop.freeze(2018, 10, 31) do
          expect(V1::PayPeriod.for(income).current_pay_day).to eq(
            Date.new(2018, 11, 6)
          )
        end
      end

      it "detects pay days on holidays" do
        income = FactoryBot.create(
          :income,
          :bi_weekly,
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