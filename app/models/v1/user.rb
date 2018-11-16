class V1::User < ApplicationRecord
  enum status: %i{
    pending
    confirmed
  }

  has_secure_token :magic_signin_token
  has_secure_token :email_confirmation_token
  has_secure_token :access_refresh_token

  def self.generate_unique_secure_token
    SecureRandom.base58(100)
  end

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

  def prepare_for_signin
    regenerate_magic_signin_token
    update(magic_signin_token_expires_at: 15.minutes.from_now)
  end
end
