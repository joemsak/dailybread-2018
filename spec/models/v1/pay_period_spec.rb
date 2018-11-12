require "rails_helper"

RSpec.describe V1::PayPeriod do
  describe ".current" do
    it "returns 1 before the 15th" do
      Timecop.freeze(2019, 1, 3) do
        expect(V1::PayPeriod.current).to eq(1)
      end
    end

    it "returns 2 on and after the 15th" do
      Timecop.freeze(2018, 11, 15) do
        expect(V1::PayPeriod.current).to eq(2)
      end

      Timecop.freeze(2018, 11, 19) do
        expect(V1::PayPeriod.current).to eq(2)
      end
    end

    it "returns 1 on the last day of the month" do
      Timecop.freeze(2018, 11, 30) do
        expect(V1::PayPeriod.current).to eq(1)
      end
    end

    it "detects pay days on weekends" do
      Timecop.freeze(2018, 12, 14) do
        expect(V1::PayPeriod.current).to eq(2)
      end
    end

    it "detects pay days on holidays" do
      Timecop.freeze(2018, 1, 12) do
        expect(V1::PayPeriod.current).to eq(2)
      end
    end
  end
end