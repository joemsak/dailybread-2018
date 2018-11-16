class V1::IncomesController < ApplicationController
  def create
    income = current_user.create_income!(income_params)
    render json: V1::IncomeSerializer.new(income).serialized_json, status: :created
  end

  def show
    render json: V1::IncomeSerializer.new(current_user.income).serialized_json
  end

  def update
    current_user.income.update(income_params)
    head 204
  end

  private
  def income_params
    params.require(:income).permit(:amount)
  end
end
