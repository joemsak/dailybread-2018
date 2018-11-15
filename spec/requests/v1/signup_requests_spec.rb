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
  end
end