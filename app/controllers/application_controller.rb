class ApplicationController < ActionController::Base
  before_action :authenticate_user

  rescue_from ActiveRecord::RecordNotFound, with: -> {
    head :not_found
  }

  private
  def authenticate_user
    V1::JWTAuth.decode(request.headers['x-access-token']) ||
      redirect_to(signin_path)
  end

  def current_user
    if decoded = V1::JWTAuth.decode(request.headers['x-access-token'])
      @current_user ||= V1::User.find(decoded.first['id'])
    end
  end
end
