require "rails_helper"

RSpec.describe "Expenses" do
  describe "POST /v1/expenses" do
    it "saves the expense" do
      expect {
        post v1_expenses_path, params: {
          expense: {
            category: "Entertainment",
            name: "tequila night",
            amount: 56.72,
            madeOn: Date.today,
          },
        }
      }.to change {
        V1::Expense.count
      }.from(0).to(1)

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)['data']
      expect(json['id']).not_to be_nil
    end
  end

  describe "GET /v1/expenses/:id" do
    it "retrieves the expense" do
      expense = FactoryBot.create(
        :expense,
        category: "Professional Development",
        amount: 350
      )

      get v1_expense_path(expense)

      json = JSON.parse(response.body)['data']
      attrs = json['attributes']

      expect(json['id']).to eq(String(expense.id))
      expect(attrs['amount']).to eq("350.0")
      expect(attrs['category']).to eq("Professional Development")
    end
  end

  describe "PATCH /v1/expenses/:id" do
    it "updates the expense" do
      expense = FactoryBot.create(
        :expense,
        category: "Professional Development",
        amount: 350
      )

      expect {
        patch v1_expense_path(expense), params: {
          expense: {
            category: "Goofing around",
            amount: 1_000_000,
            madeOn: Date.new(2015, 1, 23),
          }
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
    it "destroys the expense" do
      expense = FactoryBot.create(:expense)

      expect {
        delete v1_expense_path(expense)
      }.to change {
        V1::Expense.count
      }.from(1).to(0)
    end
  end
end