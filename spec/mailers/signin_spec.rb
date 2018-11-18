require "rails_helper"

RSpec.describe SigninMailer, type: :mailer do
  describe "send_confirmation_email" do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { SigninMailer.send_magic_link(user) }

    before do
      user.prepare_for_signin
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Sign in to Leftover Dough")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["mailer@leftoverdough.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Sign in to your account by using the button below")
      expect(mail.body.encoded).to match("This button will last until")
      expect(mail.body.encoded).to match(user.magic_signin_token_expires_at.strftime("%l:%M%p"))
      expect(mail.body.encoded).to match("If you request a new button, it will disable this one.")
      expect(mail.body.encoded).to include(root_url(magicLinkToken: user.reload.magic_signin_token))
    end
  end
end
