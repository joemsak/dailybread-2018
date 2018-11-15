class V1::ExpensesController < ApplicationController
  def index
    expenses = V1::Expense.in_current_pay_period.order(:created_at)
    render json: V1::ExpenseSerializer.new(expenses).serialized_json
  end

  def show
    expense = V1::Expense.find(params[:id])
    render json: V1::ExpenseSerializer.new(expense).serialized_json
  end

  def create
    expense = V1::Expense.create!(expense_params)
    render json: V1::ExpenseSerializer.new(expense).serialized_json, status: 201
  end

  def update
    expense = V1::Expense.find(params[:id])
    expense.update(expense_params)
    head :no_content
  end

  def destroy
    V1::Expense.find(params[:id]).destroy
    head :no_content
  end

  private
  def expense_params
    params.transform_keys(&:underscore)
      .require(:expense)
      .transform_keys(&:underscore)
      .permit(:name, :amount, :category, :made_on)
  end
end
