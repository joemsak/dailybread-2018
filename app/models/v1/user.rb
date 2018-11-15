class V1::User < ApplicationRecord
  enum status: %i{
    pending
    confirmed
  }

  has_secure_token :magic_signin_token
  has_secure_token :email_confirmation_token

  before_save -> {
    self.email_confirmation_token_expires_at = Time.current + 4.hours
  }, on: :create
end
