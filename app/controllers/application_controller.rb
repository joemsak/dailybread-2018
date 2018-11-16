class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: -> {
    head :not_found
  }

  private
  def current_user
    decoded = V1::JWTAuth.decode(
      request.headers['x-access-token']
    ) || [{ "id" => -1 }]

    @current_user ||= V1::User.confirmed.find(decoded.first['id'])
  end
end
