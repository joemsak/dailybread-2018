class V1::AccessTokenRefreshesController < ApplicationController
  def create
    if current_user.access_refresh_token == access_refresh_token
      current_user.regenerate_access_refresh_token

      jwt = V1::JWTAuth.for(current_user)
      decoded = V1::JWTAuth.decode(jwt)

      render json: {
        jwt: jwt,
        expiresAt: decoded[0]['exp'],
        refreshToken: current_user.access_refresh_token,
      }
    else
      head :not_found
    end
  end

  private
  def access_refresh_token
    params.require(:token)
  end
end