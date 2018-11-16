# Preview all emails at http://localhost:3000/rails/mailers/signin
class SigninPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/signin/send_magic_link
  def send_magic_link
    SigninMailer.send_magic_link
  end

end
