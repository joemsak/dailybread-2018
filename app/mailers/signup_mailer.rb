class SignupMailer < ApplicationMailer

  # en.signup_mailer.send_confirmation_email.subject
  def send_confirmation_email(user)
    @expiration_time = user.email_confirmation_token_expires_at.strftime(
      "%l:%M%P"
    )

    @confirmation_url = root_url(
      emailConfirmationToken: user.email_confirmation_token
    )

    mail to: user.email
  end
end