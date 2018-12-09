class V1::CheckoutsController < ApplicationController
  skip_after_action :attach_jwt_headers

  def create
    user = V1::User.find(decoded_jwt(jwt)[0]['id'])
    user.update(payment_gateway_token: token)
    redirect_to root_path
  end

  private
  def token
    params.require(:stripeToken)
  end

  def jwt
    params.require(:jwt)
  end
end
