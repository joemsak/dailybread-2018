class V1::UsersController < ApplicationController
  skip_before_action :authenticate_user

  def create
    user = V1::User.create!(user_params)
    SignupMailer.send_confirmation_email(user).deliver_later
  end

  private
  def user_params
    params.permit(:email)
  end
end
