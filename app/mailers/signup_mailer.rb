class SignupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.signup_mailer.send_confirmation_email.subject
  #
  def send_confirmation_email(user)
    @expiration_time = user.email_confirmation_token_expires_at.strftime(
      "%l:%M%P"
    )
    mail to: user.email
  end
end
