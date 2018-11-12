class V1::IncomesController < ApplicationController
  def create
    income = V1::Income.create!(income_params)
    render json: V1::IncomeSerializer.new(income).serialized_json, status: :created
  end

  def show
    income = V1::Income.last
    render json: V1::IncomeSerializer.new(income).serialized_json
  end

  def update
    V1::Income.last.update(income_params)
    head 204
  end

  private
  def income_params
    params.require(:income).permit(:amount)
  end
end
