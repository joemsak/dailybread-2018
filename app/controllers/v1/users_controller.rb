class V1::UsersController < ApplicationController
  def create
    user = V1::User.create!(user_params)
    SignupMailer.send_confirmation_email(user.email).deliver_later
  end

  private
  def user_params
    params.permit(:email)
  end
end
