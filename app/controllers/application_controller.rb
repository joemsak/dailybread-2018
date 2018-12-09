class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: -> {
    head :not_found
  }

  rescue_from JWT::ExpiredSignature, with: -> {
    head :unauthorized
  }

  after_action :attach_jwt_headers

  private
  def attach_jwt_headers(user = current_user)
    if user
      jwt = V1::JWTAuth.for(user)
      decoded = decoded_jwt(jwt)

      response.headers['x-access-token'] = jwt
      response.headers['x-access-token-expires-at'] = decoded[0]['exp']
      response.headers['x-access-refresh-token'] = user.access_refresh_token
    end
  end

  def current_user
    if decoded_jwt
      @current_user ||= V1::User.confirmed.find(decoded_jwt[0]['id'])
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def decoded_jwt(token = nil)
    if token ||= request.headers['x-access-token']
      V1::JWTAuth.decode(token) || [{ "id" => -1 }]
    end
  end
end
