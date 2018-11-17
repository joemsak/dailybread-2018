class SigninMailer < ApplicationMailer

  # en.signin_mailer.send_magic_link.subject
  def send_magic_link(user)
    @signin_url = root_url(
      magicLinkToken: user.magic_signin_token
    )

    @time = user.magic_signin_token_expires_at.strftime("%l:%M%p")

    mail to: user.email
  end
end