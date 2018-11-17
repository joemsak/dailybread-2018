class V1::UsersController < ApplicationController
  def create
    user = V1::User.find_or_create_by!(user_params)

    if user.pending?
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
