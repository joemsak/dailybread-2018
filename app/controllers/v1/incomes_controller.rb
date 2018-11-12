class V1::IncomesController < ApplicationController
  def create
    Income.create!(income_params)
  end

  private
  def income_params
    params.require(:income).permit(:amount)
  end
end
