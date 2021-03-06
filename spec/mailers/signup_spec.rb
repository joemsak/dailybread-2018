require "rails_helper"

RSpec.describe SignupMailer, type: :mailer do
  describe "send_confirmation_email" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { SignupMailer.send_confirmation_email(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Confirm your email")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mailer@leftoverdough.com"])
    end

    it "renders the body" do
      time = user.email_confirmation_token_expires_at.strftime(
        "%l:%M%P"
      )

      expect(mail.body.encoded).to match("Confirm your email by using the button below")
      expect(mail.body.encoded).to match("This button will last until")
      expect(mail.body.encoded).to match(time)
      expect(mail.body.encoded).to match("If you request a new button, it will disable this one.")
      expect(mail.body.encoded).to include(root_url(emailConfirmationToken: user.email_confirmation_token))
    end
  end
end
