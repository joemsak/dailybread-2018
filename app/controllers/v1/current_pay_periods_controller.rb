class V1::CurrentPayPeriodsController < ApplicationController
  def show
    render json: V1::PayPeriodSerializer.new(V1::PayPeriod.new).serialized_json
  end
end