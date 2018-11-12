class V1::IncomesController < ApplicationController
  def create
    Income.create!(income_params)
    head 201
  end

  def show
    income = Income.last
    render json: IncomeSerializer.new(income).serialized_json
  end

  def update
    Income.last.update(income_params)
    head 204
  end

  private
  def income_params
    params.require(:income).permit(:amount)
  end
end
