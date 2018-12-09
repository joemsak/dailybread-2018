class V1::CheckoutsController < ApplicationController
  def create
    current_user.update(
      payment_gateway_token: token
    )
  end

  private
  def token
    params.require(:stripe_token)
  end
end
