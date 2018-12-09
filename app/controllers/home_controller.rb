class HomeController < ApplicationController
  skip_after_action :attach_jwt_headers
end
