class V1::AccessTokensController < ApplicationController
  skip_after_action :attach_jwt_headers

  def create
    user = V1::User.confirmed
      .where("magic_signin_token_expires_at >= ?", Time.current)
      .find_by(magic_signin_token: magic_signin_token)

    if user
      user.expire_signin_token!
      user.regenerate_access_refresh_token
      attach_jwt_headers(user)
      head :created
    else
      head :not_found
    end
  end

  private
  def magic_signin_token
    params.require(:token)
  end
end