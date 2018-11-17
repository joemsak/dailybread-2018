class V1::EmailConfirmationsController < ApplicationController
  def create
    user = V1::User.pending.find_by(
      email_confirmation_token: email_confirmation_token
    )

    if user && user.email_confirmation_token_expires_at >= Time.current
      user.confirmed!
      jwt = V1::JWTAuth.for(user)
      render json: { jwt: jwt }
    elsif user
      user.prepare_for_signup
      SignupMailer.send_confirmation_email(user).deliver_later
      render json: {
        redirectTo: "/signup?msg=" +
          "Your signup button expired, so I sent you a new one. " +
          "You can close this window."
      }, status: 302
    else
      head :not_found
    end
  end

  private
  def email_confirmation_token
    params.require(:token)
  end
end