class V1::EmailConfirmationsController < ApplicationController
  skip_after_action :attach_jwt_headers

  def create
    user = V1::User.pending.find_by(
      email_confirmation_token: email_confirmation_token
    )

    if user && user.email_confirmation_token_expires_at >= Time.current
      user.confirmed!
      attach_jwt_headers(user)
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