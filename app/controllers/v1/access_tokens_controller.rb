class V1::AccessTokensController < ApplicationController
  def create
    user = V1::User.confirmed
      .where("magic_signin_token_expires_at >= ?", Time.current)
      .find_by(magic_signin_token: magic_signin_token)

    if user
      user.update(
        magic_signin_token_expires_at: Time.zone.local(1970, 1, 1)
      )

      user.regenerate_access_refresh_token

      jwt = V1::JWTAuth.for(user)
      decoded = V1::JWTAuth.decode(jwt)

      render json: {
        jwt: jwt,
        expiresAt: decoded[0]['exp'],
        refreshToken: user.access_refresh_token,
      }
    else
      head :not_found
    end
  end

  private
  def magic_signin_token
    params.require(:token)
  end
end