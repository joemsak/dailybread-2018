require "rails_helper"

RSpec.describe "Signups" do
  describe "POST /v1/users" do
    it "creates a pending user with their email" do
      expect {
        post v1_users_path, params: {
          email: "joe@joesak.com"
        }
      }.to change {
        V1::User.pending.count
      }.from(0).to(1)

      expect(V1::User.pending.last.email).to eq("joe@joesak.com")
    end

    it "sends the new user a confirmation email" do
      allow(SignupMailer).to receive(:send_confirmation_email).and_call_original

      post v1_users_path, params: {
        email: "joe@joesak.com"
      }

      expect(SignupMailer).to have_received(:send_confirmation_email)
                                .with(V1::User.last)

      expect {
        SignupMailer.send_confirmation_email.deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end

    it "sends an existing pending user another email" do
      user = FactoryBot.create(:user, email: "joe@joesak.com")

      allow(SignupMailer).to receive(:send_confirmation_email).and_call_original

      expect {
        post v1_users_path, params: {
          email: "joe@joesak.com"
        }
      }.not_to change {
        V1::User.pending.count
      }.from(1)

      expect(SignupMailer).to have_received(:send_confirmation_email).with(user)

      expect {
        SignupMailer.send_confirmation_email.deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end

    it "sends an existing confirmed user a signin email" do
      user = FactoryBot.create(:user, :confirmed, email: "joe@joesak.com")

      allow(SigninMailer).to receive(:send_magic_link).and_call_original
      expect(SignupMailer).not_to receive(:send_confirmation_email)

      post v1_users_path, params: {
        email: "joe@joesak.com"
      }

      expect(SigninMailer).to have_received(:send_magic_link).with(user)

      expect {
        SigninMailer.send_magic_link.deliver_later
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end