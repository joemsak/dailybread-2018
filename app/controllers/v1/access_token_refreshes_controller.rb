class V1::AccessTokenRefreshesController < ApplicationController
  def create
    if current_user.access_refresh_token == access_refresh_token
      current_user.regenerate_access_refresh_token
      head :created
    else
      head :not_found
    end
  end

  private
  def access_refresh_token
    params.require(:token)
  end
end