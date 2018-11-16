class EmailConfirmationsController < ApplicationController
  skip_before_action :authenticate_user

  def show
    user = V1::User.pending
      .where("email_confirmation_token_expires_at >= ?", Time.current)
      .find_by(email_confirmation_token: params[:id])

    if user
      user.confirmed!
      jwt = V1::JWTAuth.for(user)
      render json: { jwt: jwt }
    else
      head :not_found
    end
  end
end