class SigninsController < ApplicationController
  def create
    user = V1::User.confirmed.find_by(email: signin_email)
    user.prepare_for_signin
    SigninMailer.send_magic_link(user).deliver_later
  end

  private
  def signin_email
    params.require(:email)
  end
end
