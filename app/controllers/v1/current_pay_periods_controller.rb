class V1::CurrentPayPeriodsController < ApplicationController
  def show
    period = V1::PayPeriod.for(current_user.income)
    render json: V1::PayPeriodSerializer.new(period).serialized_json
  end
end