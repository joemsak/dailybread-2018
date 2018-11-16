class V1::EmailConfirmationsController < ApplicationController
  def create
    user = V1::User.pending
      .where("email_confirmation_token_expires_at >= ?", Time.current)
      .find_by(email_confirmation_token: email_confirmation_token)

    if user
      user.confirmed!
      jwt = V1::JWTAuth.for(user)
      render json: { jwt: jwt }
    else
      head :not_found
    end
  end

  private
  def email_confirmation_token
    params.require(:token)
  end
end