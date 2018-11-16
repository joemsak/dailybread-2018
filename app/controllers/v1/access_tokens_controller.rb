class V1::AccessTokensController < ApplicationController
  def create
    user = V1::User.confirmed
      .where("magic_signin_token_expires_at >= ?", Time.current)
      .find_by(magic_signin_token: magic_signin_token)

    if user
      user.update(
        magic_signin_token_expires_at: Time.zone.local(1970, 1, 1)
      )
      jwt = V1::JWTAuth.for(user)
      render json: { jwt: jwt }
    else
      head :not_found
    end
  end

  private
  def magic_signin_token
    params.require(:token)
  end
end