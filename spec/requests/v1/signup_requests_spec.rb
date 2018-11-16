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
  end
end