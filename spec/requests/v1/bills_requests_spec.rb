require "rails_helper"

RSpec.describe "Bills" do
  let!(:user) { FactoryBot.create(:user, :confirmed) }
  let(:jwt) { V1::JWTAuth.for(user) }

  describe "POST /v1/bills" do
    it "saves the user's bill" do
      expect {
        post v1_bills_path, params: {
          bill: {
            name: "Rent",
            payPeriod: 1,
            amount: 350
          },
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.bills.count
      }.from(0).to(1)

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)['data']
      expect(json['id']).not_to be_nil
    end

    it "saves the user's bills with 'current' pay_period" do
      Timecop.freeze(Date.new(2018, 11, 15)) do
        expect {
          post v1_bills_path, params: {
            bill: {
              name: "Rent",
              payPeriod: "current",
              amount: 350
            },
          }, headers: {
            'x-access-token' => jwt
          }
        }.to change {
          user.bills.count
        }.from(0).to(1)
      end

      json = JSON.parse(response.body)['data']
      expect(json['attributes']['payPeriod']).to eq(2)
    end
  end

  describe "GET /v1/bills?payPeriod=:period" do
    it "retrieves all the user's bills in period 1" do
      bill = FactoryBot.create(:bill, user: user, pay_period: 1)
      FactoryBot.create(:bill, user: user, pay_period: 2)
      FactoryBot.create(:bill, pay_period: 1)

      get v1_bills_path, params: {
        payPeriod: 1
      }, headers: {
        'x-access-token' => jwt
      }

      json = JSON.parse(response.body)['data']
      expect(json.count).to eq(1)
      expect(json[0]['id']).to eq(String(bill.id))
    end

    it "retrieves all the user's bills in period 2" do
      bill = FactoryBot.create(:bill, user: user, pay_period: 2)
      FactoryBot.create(:bill, user: user, pay_period: 1)
      FactoryBot.create(:bill, pay_period: 2)

      get v1_bills_path, params: {
        payPeriod: 2
      }, headers: {
        'x-access-token' => jwt
      }

      json = JSON.parse(response.body)['data']
      expect(json.count).to eq(1)
      expect(json[0]['id']).to eq(String(bill.id))
    end

    it "retrieves all the user's bills in the current period" do
      bill2 = FactoryBot.create(:bill, user: user, pay_period: 2)
      bill1 = FactoryBot.create(:bill, user: user, pay_period: 1)
      FactoryBot.create(:bill, pay_period: 2)
      FactoryBot.create(:bill, pay_period: 1)

      Timecop.freeze(Date.new(2019, 6, 14)) do
        get v1_bills_path, params: {
          payPeriod: :current
        }, headers: {
          'x-access-token' => jwt
        }
      end

      json = JSON.parse(response.body)['data']
      expect(json.count).to eq(1)
      expect(json[0]['id']).to eq(String(bill2.id))

      Timecop.freeze(Date.new(2019, 6, 28)) do
        new_jwt = V1::JWTAuth.for(user)

        get v1_bills_path, params: {
          payPeriod: :current
        }, headers: {
          'x-access-token' => new_jwt
        }
      end

      json = JSON.parse(response.body)['data']
      expect(json.count).to eq(1)
      expect(json[0]['id']).to eq(String(bill1.id))
    end
  end

  describe "GET /v1/bills/:id" do
    it "retrieves the user's bill" do
      bill = FactoryBot.create(:bill, user: user, pay_period: 2, name: "Rent", amount: 350)
      other = FactoryBot.create(:bill)

      get v1_bill_path(other), headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      get v1_bill_path(bill), headers: {
        'x-access-token' => jwt
      }

      json = JSON.parse(response.body)['data']
      attrs = json['attributes']

      expect(json['id']).to eq(String(bill.id))
      expect(attrs['amount']).to eq(350)
      expect(attrs['payPeriod']).to eq(2)
      expect(attrs['name']).to eq("Rent")
    end
  end

  describe "PATCH /v1/bills/:id" do
    it "updates the user's bill" do
      bill = FactoryBot.create(:bill, user: user, pay_period: 2, name: "Rent", amount: 350)
      other = FactoryBot.create(:bill)

      patch v1_bill_path(other), params: {
        bill: {
          name: "Car payment",
          amount: 1_000_000,
          payPeriod: 1,
        },
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      expect {
        patch v1_bill_path(bill), params: {
          bill: {
            name: "Car payment",
            amount: 1_000_000,
            payPeriod: 1,
          }
        }, headers: {
          'x-access-token' => jwt
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
    it "destroys the user's bill" do
      bill = FactoryBot.create(:bill, user: user)
      other = FactoryBot.create(:bill)

      delete v1_bill_path(other), headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      expect {
        delete v1_bill_path(bill), headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.bills.count
      }.from(1).to(0)
    end
  end
end