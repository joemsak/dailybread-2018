class V1::IncomesController < ApplicationController
  def create
    income = current_user.create_income!(income_params)
    render json: V1::IncomeSerializer.new(income).serialized_json, status: :created
  end

  def show
    if income = current_user.income
      render json: V1::IncomeSerializer.new(income).serialized_json
    else
      head :not_found
    end
  end

  def update
    current_user.income.update(income_params)
    head :no_content
  end

  private
  def income_params
    params.require(:income).permit(:amount, :payroll_type)
  end
end
