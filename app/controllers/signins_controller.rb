class SigninsController < ApplicationController
  def create
    user = V1::User.find_by(email: signin_email)
    if user.confirmed?
      user.prepare_for_signin
      SigninMailer.send_magic_link(user).deliver_later
    else
      user.prepare_for_signup
      SignupMailer.send_confirmation_email(user).deliver_later
    end
  end

  private
  def signin_email
    params.require(:email)
  end
end
