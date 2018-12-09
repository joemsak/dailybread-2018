require "rails_helper"

RSpec.describe "Expenses" do
  let!(:user) { FactoryBot.create(:user, :confirmed) }
  let(:jwt) { V1::JWTAuth.for(user) }

  describe "GET /v1/expenses" do
    it "only returns the user's expenses in the current pay period" do
      expense1 = FactoryBot.create(:expense, user: user, made_on: Date.new(2018, 12, 14))
      expense2 = FactoryBot.create(:expense, user: user, made_on: Date.new(2018, 12, 13))
      FactoryBot.create(:expense, made_on: Date.new(2018, 12, 13))

      Timecop.freeze(Date.new(2018, 12, 14)) do
        get v1_expenses_path(format: :json), headers: {
          'x-access-token' => jwt
        }

        json = JSON.parse(response.body)['data']
        expect(json.count).to eq(1)
        expect(json[0]['id']).to eq(String(expense1.id))
      end

      Timecop.freeze(Date.new(2018, 12, 13)) do
        get v1_expenses_path(format: :json), headers: {
          'x-access-token' => jwt
        }

        json = JSON.parse(response.body)['data']
        expect(json.count).to eq(1)
        expect(json[0]['id']).to eq(String(expense2.id))
      end
    end
  end

  describe "POST /v1/expenses" do
    it "saves the user's expense" do
      allow(V1::JWTAuth).to receive(:for) { "abc123" }

      allow(V1::JWTAuth).to receive(:decode) {
        [{
          'exp' => 1234567890,
          'id' => user.id,
        }]
      }

      expect {
        post v1_expenses_path(format: :json), params: {
          expense: {
            category: "Entertainment",
            name: "tequila night",
            amount: 56.72,
            madeOn: Date.today,
          },
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.expenses.count
      }.from(0).to(1)

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)['data']
      expect(json['id']).not_to be_nil

      headers = response.headers
      expect(headers['x-access-token']).to eq('abc123')
    end
  end

  describe "GET /v1/expenses/:id" do
    it "retrieves the user's expense" do
      expense = FactoryBot.create(
        :expense,
        user: user,
        category: "Professional Development",
        amount: 350
      )

      other = FactoryBot.create(:expense)

      get v1_expense_path(other, format: :json), headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      get v1_expense_path(expense, format: :json), headers: {
        'x-access-token' => jwt
      }

      json = JSON.parse(response.body)['data']
      attrs = json['attributes']

      expect(json['id']).to eq(String(expense.id))
      expect(attrs['amount']).to eq("350.0")
      expect(attrs['category']).to eq("Professional Development")
    end
  end

  describe "PATCH /v1/expenses/:id" do
    it "updates the user's expense" do
      expense = FactoryBot.create(
        :expense,
        user: user,
        category: "Professional Development",
        amount: 350
      )

      other = FactoryBot.create(:expense)

      patch v1_expense_path(other, format: :json), params: {
        expense: {
          category: "Goofing around",
          amount: 1_000_000,
          madeOn: Date.new(2015, 1, 23),
        }
      }, headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      expect {
        patch v1_expense_path(expense, format: :json), params: {
          expense: {
            category: "Goofing around",
            amount: 1_000_000,
            madeOn: Date.new(2015, 1, 23),
          }
        }, headers: {
          'x-access-token' => jwt
        }
      }.to change {
        expense.reload.amount
      }.from(350).to(1_000_000)
      .and change {
        expense.reload.category
      }.from("Professional Development").to("Goofing around")
      .and change {
        expense.reload.made_on
      }.from(Date.today).to(Date.new(2015, 1, 23))

      expect(response.status).to eq(204)
    end
  end

  describe "DELETE /v1/expenses/:id" do
    it "destroys the user's expense" do
      expense = FactoryBot.create(:expense, user: user)
      other = FactoryBot.create(:expense)

      delete v1_expense_path(other, format: :json), headers: {
        'x-access-token' => jwt
      }

      expect(response.status).to eq(404)

      expect {
        delete v1_expense_path(expense, format: :json), headers: {
          'x-access-token' => jwt
        }
      }.to change {
        user.expenses.count
      }.from(1).to(0)
    end
  end
end