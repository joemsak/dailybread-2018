# Preview all emails at http://localhost:3000/rails/mailers/signup
class SignupPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/signup/send_confirmation_email
  def send_confirmation_email
    SignupMailer.send_confirmation_email
  end

end
