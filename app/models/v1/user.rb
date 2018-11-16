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

  after_commit -> {
    if saved_change_to_status? && confirmed?
      update_column(
        :email_confirmation_token_expires_at,
        Time.zone.local(1970, 1, 1)
      )
    end
  }, on: :update

  has_one :income
  has_many :expenses
  has_many :bills
end
