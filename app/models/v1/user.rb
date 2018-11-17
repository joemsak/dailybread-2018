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

  after_commit -> {
    expire_signup_token! if saved_change_to_status? && confirmed?
  }, on: :update

  has_one :income, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :bills, dependent: :destroy

  def prepare_for_signup
    if persisted?
      update_column(:email_confirmation_token_expires_at, Time.current + 4.hours)
      regenerate_email_confirmation_token
    else
      self.email_confirmation_token_expires_at = Time.current + 4.hours
      save
    end
  end

  def prepare_for_signin
    update(magic_signin_token_expires_at: 15.minutes.from_now)
    regenerate_magic_signin_token
  end

  def expire_signin_token!
    update_column(:magic_signin_token_expires_at, Time.zone.local(0))
  end

  def expire_signup_token!
    update_column(:email_confirmation_token_expires_at, Time.zone.local(0))
  end
end
