class V1::UsersController < ApplicationController
  def create
    user = V1::User.find_or_initialize_by(user_params)

    if user.pending?
      user.prepare_for_signup_with_save
      SignupMailer.send_confirmation_email(user).deliver_later
    else
      user.prepare_for_signin
      SigninMailer.send_magic_link(user).deliver_later
    end
  end

  private
  def user_params
    params.permit(:email)
  end
end
