require "rails_helper"

RSpec.describe "Signins" do
  describe "POST /signins" do
    it "sends the new user a magic link email" do
      user = FactoryBot.create(:user, :confirmed, email: "joe@joesak.com")

      allow(SigninMailer).to receive(:send_magic_link).and_call_original

      post signin_path, params: {
        email: "joe@joesak.com"
      }

      expect(SigninMailer).to have_received(:send_magic_link).with(user)

      expect {
        SigninMailer.send_magic_link.deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end