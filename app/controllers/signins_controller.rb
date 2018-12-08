class SigninsController < ApplicationController
  layout :resolve_layout

  def create
    user = V1::User.find_or_initialize_by(email: signin_email)

    if user.pending?
      user.prepare_for_signup_with_save
      SignupMailer.send_confirmation_email(user).deliver_later
    else
      user.prepare_for_signin
      SigninMailer.send_magic_link(user).deliver_later
    end
  end

  private
  def signin_email
    params.require(:email)
  end

  def resolve_layout
    case action_name
    when "new"; "application"
    else;       "plain"
    end
  end
end
