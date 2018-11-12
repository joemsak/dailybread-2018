require "rails_helper"

RSpec.describe "Bills" do
  describe "POST /v1/bills" do
    it "saves the bill" do
      expect {
        post v1_bills_path, params: {
          bill: {
            name: "Rent",
            pay_period: 1,
            amount: 350
          },
        }
      }.to change {
        V1::Bill.count
      }.from(0).to(1)

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)['data']
      expect(json['id']).not_to be_nil
    end
  end

  describe "GET /v1/bills?pay_period=:period" do
    it "retrieves all bills in period 1" do
      bill = FactoryBot.create(:bill, pay_period: 1)
      FactoryBot.create(:bill, pay_period: 2)

      get v1_bills_path, params: {
        pay_period: 1
      }

      json = JSON.parse(response.body)['data']
      expect(json.count).to be 1
      expect(json[0]['id']).to eq(String(bill.id))
    end

    it "retrieves all bills in period 2" do
      bill = FactoryBot.create(:bill, pay_period: 2)
      FactoryBot.create(:bill, pay_period: 1)

      get v1_bills_path, params: {
        pay_period: 2
      }

      json = JSON.parse(response.body)['data']
      expect(json.count).to be 1
      expect(json[0]['id']).to eq(String(bill.id))
    end

    it "retrieves all bills in the current period" do
      bill2 = FactoryBot.create(:bill, pay_period: 2)
      bill1 = FactoryBot.create(:bill, pay_period: 1)

      Timecop.freeze(Date.new(2019, 6, 14)) do
        get v1_bills_path, params: {
          pay_period: :current
        }
      end

      json = JSON.parse(response.body)['data']
      expect(json.count).to be 1
      expect(json[0]['id']).to eq(String(bill2.id))

      Timecop.freeze(Date.new(2019, 6, 28)) do
        get v1_bills_path, params: {
          pay_period: :current
        }
      end

      json = JSON.parse(response.body)['data']
      expect(json.count).to be 1
      expect(json[0]['id']).to eq(String(bill1.id))
    end
  end

  describe "GET /v1/bills/:id" do
    it "retrieves the bill" do
      bill = FactoryBot.create(:bill, pay_period: 2, name: "Rent", amount: 350)

      get v1_bill_path(bill)

      json = JSON.parse(response.body)['data']
      attrs = json['attributes']

      expect(json['id']).to eq(String(bill.id))
      expect(attrs['amount']).to eq(350)
      expect(attrs['pay_period']).to eq(2)
      expect(attrs['name']).to eq("Rent")
    end
  end

  describe "PATCH /v1/bills/:id" do
    it "updates the bill" do
      bill = FactoryBot.create(:bill, pay_period: 2, name: "Rent", amount: 350)

      expect {
        patch v1_bill_path(bill), params: {
          bill: {
            name: "Car payment",
            amount: 1_000_000,
            pay_period: 1,
          }
        }
      }.to change {
        bill.reload.amount
      }.from(350).to(1_000_000)
      .and change {
        bill.reload.name
      }.from("Rent").to("Car payment")
      .and change {
        bill.reload.pay_period
      }.from(2).to(1)

      expect(response.status).to eq(204)
    end
  end

  describe "DELETE /v1/bills/:id" do
    it "destroys the bill" do
      bill = FactoryBot.create(:bill)

      expect {
        delete v1_bill_path(bill)
      }.to change {
        V1::Bill.count
      }.from(1).to(0)
    end
  end
end